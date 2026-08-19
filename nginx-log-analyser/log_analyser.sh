#!/bin/bash
set -euo pipefail

# --- ANSI Escape Codes for Terminal Colorization ---
NC='\033[0m'        # Text Reset (No Color)
GREEN='\033[0;32m'   # Section Headers
YELLOW='\033[0;33m'  # Metric Labels
BLUE='\033[0;34m'    # Visual Separators
CYAN='\033[0;36m'    # Bandwidth Details
BOLD='\033[1m'       # Bold Styling

# --- Default Context Variables ---
LIMIT=5
LOG_FILE=""

# --- Display Usage Function ---
show_usage() {
    echo "Usage: $0 [-n limit] <path_to_nginx_access_log>"
    exit 1
}

# --- Parse Command-Line Options (CLI Parsing) ---
while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--limit)
            LIMIT="$2"
            shift 2
            ;;
        *)
            LOG_FILE="$1"
            shift
            ;;
    esac
done

# --- Validate Inputs ---
if [ -z "$LOG_FILE" ]; then
    echo "[-] Error: Missing Nginx access log file path." >&2
    show_usage
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "[-] Error: Target file '$LOG_FILE' does not exist." >&2
    exit 1
fi

# ==============================================================================
# --- Core Metrics Extraction Functions ---
# ==============================================================================

# Unified text processing framework supporting multi-delimiters (DRY Principle)
extract_top_metrics() {
    local field_number="$1"
    local delimiter="${2:- }" # Defaults to space separator
    
    if [ "$delimiter" = '"' ]; then
        awk -F'"' "{print \$$field_number}" "$LOG_FILE" | sort | uniq -c | sort -nr | head -n "$LIMIT"
    else
        awk "{print \$$field_number}" "$LOG_FILE" | sort | uniq -c | sort -nr | head -n "$LIMIT"
    fi
}

# Advanced metrics engine to compute total network footprint per route
calculate_bandwidth() {
    echo -e "${CYAN}${BOLD}Total Bandwidth Consumed by Top Paths:${NC}"
    # Group by path ($7), aggregate bytes ($10), sort descending, convert to Megabytes
    awk '{sum[$7]+=$10} END {for (path in sum) print sum[path], path}' "$LOG_FILE" \
        | sort -nr \
        | head -n "$LIMIT" \
        | awk '{printf "  %s - %.4f MB\n", $2, $1/1024/1024}'
}

# --- Human-Readable Terminal Formatter Engine ---
render_text_report() {
    echo -e "${BLUE}${BOLD}==================================================${NC}"
    echo -e "${GREEN}${BOLD}          NGINX LOG ANALYSIS REPORT               ${NC}"
    echo -e "${BLUE}${BOLD}==================================================${NC}\n"

    # 1. Top IP Addresses
    echo -e "${YELLOW}${BOLD}Top $LIMIT IP Addresses with Most Requests:${NC}"
    extract_top_metrics 1 " " | awk '{print "  " $2 " - " $1 " requests"}'
    echo ""

    # 2. Top Requested Paths
    echo -e "${YELLOW}${BOLD}Top $LIMIT Most Requested Paths:${NC}"
    extract_top_metrics 7 " " | awk '{print "  " $2 " - " $1 " requests"}'
    echo ""

    # 3. Top Response Status Codes
    echo -e "${YELLOW}${BOLD}Top $LIMIT Response Status Codes:${NC}"
    extract_top_metrics 9 " " | awk '{print "  " $2 " - " $1 " requests"}'
    echo ""

    # 4. Top User Agents (Field 6 when splitting by double quotes)
    echo -e "${YELLOW}${BOLD}Top $LIMIT User Agents:${NC}"
    extract_top_metrics 6 '"' | sed -E 's/^[[:space:]]*([0-9]+)[[:space:]]+(.*)/  \2 - \1 requests/'
    echo ""
    
    # 5. Core Network Footprint
    calculate_bandwidth
    echo ""
}

# --- Run the Formatter Engine ---
render_text_report
