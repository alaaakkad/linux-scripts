# Log Archive Tool

A simple and efficient Bash script to automate the archiving and compression of Linux log directories. This project helps in managing disk space by packaging old logs into timestamped compressed files and maintaining a historical execution log.

This project is part of the learning challenges from **roadmap.sh**.
- **Project Page:** https://roadmap.sh

## Features
- **Input Validation:** Verifies that a directory argument is provided and that the directory actually exists.
- **Automated Compression:** Bundles and compresses logs into `.tar.gz` format using the `tar` utility.
- **Unique Timestamps:** Generates dynamic filenames based on the exact execution time (`YYYYMMDD_HHMMSS`) to avoid overwriting backups.
- **Activity Logging:** Records every success or failure event with a timestamp in a local `archive.log` file.

## Requirements
- Linux/Unix environment
- Bash shell
- `tar` and `gzip` utilities (pre-installed on most Linux distributions)

## How to Use

1. **Clone the repository** (if you haven't already):
   ```bash
   git clone https://github.com
   cd linux-scripts/log-archive
   ```

2. **Make the script executable**:
   ```bash
   chmod +x log-archive.sh
   ```

3. **Run the script** by providing the path to the directory you want to archive:
   ```bash
   ./log-archive.sh <path-to-log-directory>
   ```
   *Example:*
   ```bash
   ./log-archive.sh /var/log/nginx
   ```

## Output Structure
- **Compressed Files:** Saved in a dynamically created directory named `compressed_logs/`.
- **Execution History:** Appended to `archive.log` in the following format:
  ```text
  [2026-08-15 09:04:18] SUCCESS: Archived '.' to 'compressed_logs/logs_archive_20260815_090418.tar.gz'
  ```

