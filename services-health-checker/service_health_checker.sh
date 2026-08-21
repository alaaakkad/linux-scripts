#!/usr/bin/env bash

# 1. Define configuration files and Log File path
SERVICES_FILE="services.txt"
LOG_FILE="/var/log/service_checker.log"

# 2. Security Check: Verify if the configuration file exists before starting
if [ ! -f "${SERVICES_FILE}" ]; then
    echo "[-] Critical Error: Configuration file '${SERVICES_FILE}' not found!"
    exit 1
fi

# 3. Log File Initialization: Create the log file if it doesn't exist
if [ ! -f "${LOG_FILE}" ]; then
    touch "${LOG_FILE}" 2>/dev/null
    # If touch fails due to permissions, warn the user but keep output on screen
    if [ $? -ne 0 ]; then
        echo "[-] Warning: Cannot write to ${LOG_FILE}. Ensure you are running as root/sudo."
        LOG_FILE="/dev/null" # Redirect logs to null to prevent script crash
    fi
fi

echo "[+] Configuration file found successfully."
echo "[+] Profiling and checking system services status:"
echo "------------------------------------------------"

# 4. Read loop to process the file line by line
while IFS= read -r SERVICE || [ -n "${SERVICE}" ]; do
    
    # 5. Sanitize input: Skip empty lines or lines starting with '#' (comments)
    [[ -z "${SERVICE}" || "${SERVICE}" =~ ^# ]] && continue
    
    # Trim leading and trailing whitespaces using xargs
    SERVICE=$(echo "${SERVICE}" | xargs)

    # 6. Advanced Check: Verify if the service is actually registered in the system
    if ! systemctl list-unit-files --type=service | grep -q "^${SERVICE}.service"; then
        echo "• [${SERVICE}] -> [NOT FOUND] ⚠️"
        continue
    fi

    # 7. Live Health Check: Query the systemd subsystem for service state
    if systemctl is-active --quiet "${SERVICE}"; then
        echo "• [${SERVICE}] -> [RUNNING]  "
    else
        echo "• [${SERVICE}] -> [DOWN] 🚨"
        echo "  └─► Attempting auto-recovery: Executing 'systemctl restart ${SERVICE}'..."
        
        # Trigger the recovery operation via systemd
        systemctl restart "${SERVICE}"
        
        # Post-check validation: Wait for the kernel to allocate memory/ports
        sleep 2
        
        # Check if the service stabilized or failed to boot
        if systemctl is-active --quiet "${SERVICE}"; then
            echo "  └─► [RECOVERED] ✅ Service successfully revived and stabilized."
            
            # Write SUCCESS event to the local log file
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [SUCCESS] Service '${SERVICE}' went DOWN but was successfully RECOVERED on host '$(hostname)'." >> "${LOG_FILE}"
        else
            echo "  └─► [FAILED] ❌ Recovery failed. Manual intervention required!"
            
            # Write CRITICAL event to the local log file
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] [CRITICAL] Service '${SERVICE}' went DOWN and auto-recovery FAILED on host '$(hostname)'!" >> "${LOG_FILE}"
        fi
    fi

done < "${SERVICES_FILE}"

echo "------------------------------------------------"
echo "[+] Stage 4 completed: Local logging routine finished."

