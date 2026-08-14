# Server Performance Stats

A lightweight Bash script to analyze and monitor basic server performance metrics on any Linux system. 

## Features
- **System Info:** Displays the OS version and server uptime.
- **CPU Usage:** Calculates total active CPU utilization percentage.
- **Memory Usage:** Shows total, used, and free RAM with usage percentage.
- **Disk Usage:** Displays total, used, and free disk space with usage percentage.
- **Top Processes:** Lists the top 5 running processes by CPU and memory consumption.

## Requirements
- Linux-based operating system (Ubuntu, Debian, CentOS, etc.)
- Standard utilities: `awk`, `sed`, `grep`, `top`, `free`, `df`, `ps`

## How to Use

1. **Navigate to the script directory:**
   ```bash
   cd server-stats
   ```

2. **Make the script executable:**
   ```bash
   chmod +x server-stats.sh
   ```

3. **Run the script:**
   ```bash
   ./server-stats.sh
   ```

