#!/bin/bash
# Function to print a divider line for better UI readability
print_divider() {
	echo "====================================================="
}

# Print main header
print_divider
echo "			SERVER PERFORMANCE STATS			"
print_divider

# 1. Display System Information (Stretch Goals)
echo "--- System Information ---"
echo "OS Version:   $(cat /etc/os-release | grep -w "PRETTY_NAME" | cut -d= -f2 | tr -d '"')"
echo "Server Uptime: $(uptime -p)"
print_divider
# 2. Display Total Memory Usage (Free vs Used with percentage)
echo "--- Memory Usage ---"
free -m | awk 'NR==2{printf "Used: %dMB / Total: %dMB (%.2f%%)\nFree: %dMB\n", $3, $2, $3*100/$2, $4}'
print_divider
# 3. Display Total CPU Usage
echo "--- CPU Usage ---"
# Get the idle CPU percentage
cpu_idle=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
# Calculate used CPU (100 - idle) using awk for decimal points
cpu_usage=$(awk "BEGIN {print 100 - $cpu_idle}")
echo "Total CPU Usage: ${cpu_usage}%"
print_divider
# 4. Display Total Disk Usage (Free vs Used with percentage)
echo "--- Disk Usage ---"
df -h / | awk 'NR==2{printf "Used: %s / Total: %s (%s)\nFree: %s\n", $3, $2, $5, $4}'
print_divider
# 5. Display Top 5 Processes by CPU Usage
echo "--- Top 5 Processes by CPU Usage ---"
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6
print_divider

# 6. Display Top 5 Processes by Memory Usage
echo "--- Top 5 Processes by Memory Usage ---"
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6
print_divider

