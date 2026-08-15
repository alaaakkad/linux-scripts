#!/bin/bash

# Store the log directory path provided by the user
LOG_DIR=$1

# Step 1: Check if the argument is missing (empty variable)
if [ -z "$LOG_DIR" ]; then
    echo "⚠️ Error: Please specify the log directory path."
    echo "Usage: $0 <log-directory>"
    exit 1
fi

# Step 2: Check if the directory actually exists on the system
if [ ! -d "$LOG_DIR" ]; then
    echo "❌ Error: Directory '$LOG_DIR' does not exist."
    exit 1
fi

# If everything is correct so far
echo "✅ Valid directory found: $LOG_DIR"
# Step 3: Create the archive backup directory if it doesn't exist
ARCHIVE_DEST="compressed_logs"
mkdir -p "$ARCHIVE_DEST"

# Step 4: Generate a unique filename using current date and time
# Format will look like: logs_archive_20260815_115400.tar.gz
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"

# Just a test message to see our generated name
echo "📦 Ready to archive into: $ARCHIVE_DEST/$ARCHIVE_NAME"

# Step 5: Compress and archive the specified log directory
echo "⚡ Archiving in progress... Please wait."

tar -czf "$ARCHIVE_DEST/$ARCHIVE_NAME" "$LOG_DIR"

# Check if the tar command succeeded
if [ $? -eq 0 ]; then
    echo "🎉 Success! Directory archived successfully."
    echo "📄 File location: $ARCHIVE_DEST/$ARCHIVE_NAME"
    
    # Step 6: Log the success event to an external log file
    # We use '>>' to append the text to the end of the file without overwriting it
    LOG_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$LOG_TIMESTAMP] SUCCESS: Archived '$LOG_DIR' to '$ARCHIVE_DEST/$ARCHIVE_NAME'" >> archive.log

else
    echo "❌ Error: Failed to create archive."
    
    # Optional: Log the failure event too
    LOG_TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$LOG_TIMESTAMP] ERROR: Failed to archive '$LOG_DIR'" >> archive.log
    exit 1
fi
