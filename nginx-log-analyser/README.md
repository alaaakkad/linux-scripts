# Pro Nginx Log Analyser

A high-performance command-line Bash utility featuring strict error handling and real-time log data streaming to extract immediate network insights from Nginx access files.

## Architectural Features
- **Strict Defensive Execution:** Runs with `set -euo pipefail` to ensure zero hidden pipeline failures.
- **Traffic Fingerprinting:** Isolates Top IPs, Resource Paths, Status Codes, and User Agents dynamically.
- **Data Footprint Metrics:** Dynamically computes bandwidth sizing profiles in Megabytes (MB).

## CLI Execution Guide
```bash
# Analyze target files and slice the visibility matrix to the top 3 items
./log_analyzer.sh -n 3 live_logs/access.log
```
