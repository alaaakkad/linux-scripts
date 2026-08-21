# Linux Service Health Checker & Auto-Recovery Engine

A production-grade, automated bash utility designed for Linux Platform Engineers and DevOps teams to monitor, audit, and self-heal critical systemd services locally with zero-noise logging and absolute resource efficiency.

## 🚀 Key Architectural Features
- **Decoupled Architecture:** Configuration list is completely isolated from the execution logic, utilizing standard Linux file layout schemas.
- **Self-Healing Mechanism:** Automatically detects `DOWN` states and safely invokes recovery routines via systemd.
- **Resource Guard & Defensive Programming:** Implements robust sanitization (`xargs`/Regex), safe token parsing (`IFS`), and early-exit mechanisms to prevent resource leakage or zombie processes.
- **Native Systemd Timer Orchestration:** Scheduled precisely down to the second via custom Systemd Timers as a modern, reliable alternative to legacy Cron Jobs.
- **Smart Local Logging:** Writes unified, time-stamped events sequentially (`>>`) only during transitions to eliminate disk-space waste.

## 📂 Production Directory Layout
To adhere to standard enterprise compliance, the system component distribution is as follows:
- **Executable Script:** `/usr/local/bin/service_health_checker.sh` (Permissions: `700`, Owner: `root`)
- **Service Configuration:** `/etc/services_to_check.txt` (Permissions: `644`, Owner: `root`)
- **Audit Logs:** `/var/log/service_checker.log`
- **Systemd Descriptors:** `/etc/systemd/system/healthchecker.*`

## 🛠️ Automated Setup & Installation

1. Deploy the core script and apply strict root-only permissions:
   ```bash
   sudo cp service_health_checker.sh /usr/local/bin/
   sudo chmod 700 /usr/local/bin/service_health_checker.sh
   sudo chown root:root /usr/local/bin/service_health_checker.sh
   ```
2. Establish your global service watch list:
   ```bash
   sudo cp services.txt /etc/services_to_check.txt
   sudo chmod 644 /etc/services_to_check.txt
   ```
3. Link the Systemd units and boot the background daemon timer:
   ```bash
   sudo cp systemd/healthchecker.service /etc/systemd/system/
   sudo cp systemd/healthchecker.timer /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable --now healthchecker.timer
   ```

## 📊 Observability & Verification
Monitor the live countdown and trigger tracking via:
```bash
sudo systemctl list-timers --all | grep healthchecker
sudo journalctl -u healthchecker.service -n 20 --no-pager
sudo cat /var/log/service_checker.log
```

