#!/bin/bash
#backup mysql database script
# Source the environment variables from .env
source '.env'

BACKUP_DIR="path/to/backup"
ZIP_PASSWORD="your password"
EXCLUDED_TABLES=("table1_to_exclude" "table2_to_exclude" "table3_to_exclude")

DB_USERNAME="$DB_USERNAME"
DB_PASSWORD="$DB_PASSWORD"
DB_DATABASE="$DB_DATABASE"

TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="$BACKUP_DIR/$DB_DATABASE-$TIMESTAMP.sql"
ZIP_FILE="$BACKUP_DIR/$DB_DATABASE-$TIMESTAMP.zip"

# Create backup using mysqldump, excluding data from specified tables
mysqldump_cmd="mysqldump -u$DB_USERNAME -p$DB_PASSWORD $DB_DATABASE"

for table in "${EXCLUDED_TABLES[@]}"; do
    mysqldump_cmd+=" --ignore-table=$DB_DATABASE.$table --no-data"
done

$mysqldump_cmd > $BACKUP_FILE

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
