#!/bin/bash

# MySQL database credentials
DB_USER="your_username"
DB_PASSWORD="your_password"
DB_NAME="your_database_name"

# Output directory and file names
BACKUP_DIR="/path/to/backup"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$BACKUP_DIR/$DB_NAME-$TIMESTAMP.sql"
ZIP_FILE="$BACKUP_DIR/$DB_NAME-$TIMESTAMP.zip"
ZIP_PASSWORD="your_zip_password"

# Create backup using mysqldump
mysqldump -u$DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_FILE

# Check if mysqldump was successful
if [ $? -eq 0 ]; then
    # Compress the backup file into a ZIP file with password
    zip --encrypt --password $ZIP_PASSWORD $ZIP_FILE $BACKUP_FILE

    # Remove the original SQL backup file
    rm $BACKUP_FILE

    echo "Backup completed successfully. ZIP file: $ZIP_FILE"
else
    echo "Error: MySQL backup failed."
fi
