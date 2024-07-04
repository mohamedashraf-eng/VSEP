#!/bin/bash

# Database credentials
DB_USER="root"
DB_PASS=""
DB_HOST="localhost"
DB_NAME="myFOTA"
TABLE_NAME="website_fota_firmware"

# Firmware details
VERSION="1.0.0"
RELEASE_DATE="2024-06-29"
FIRMWARE_FILE="~/Documents/CMAKE_GP/website/fota/firmwares/UpdatedFirmware.hex"
HASH_FILE_PATH="~/Documents/CMAKE_GP/website/fota/firmwares/UpdatedFirmwareHash.txt"
IS_ACTIVE=1
DESCRIPTION=""

# Expand paths
FIRMWARE_FILE=$(eval echo $FIRMWARE_FILE)
HASH_FILE_PATH=$(eval echo $HASH_FILE_PATH)

# Extract hash and size from the hash file
extract_hash_and_size() {
    local hash_file_path=$1
    local firmware_hash=""
    local firmware_size=""

    if [[ -f $hash_file_path ]]; then
        firmware_hash=$(grep -oP '(?<=Hash\(SHA256\): )\w+' "$hash_file_path")
        firmware_size=$(grep -oP '(?<=Size\(Bytes\): )\d+' "$hash_file_path")
    fi

    echo "$firmware_hash" "$firmware_size"
}

read firmware_hash firmware_size <<< $(extract_hash_and_size "$HASH_FILE_PATH")

# MySQL command to insert a new record
INSERT_QUERY="INSERT INTO $TABLE_NAME (version, release_date, firmware, is_active, firmware_cmac, firmware_size, description) VALUES ('$VERSION', '$RELEASE_DATE', '$FIRMWARE_FILE', $IS_ACTIVE, '$firmware_hash', '$firmware_size', '$DESCRIPTION');"

# Execute the MySQL command
mysql -u"$DB_USER" -h "$DB_HOST" -D "$DB_NAME" -e "$INSERT_QUERY"

if [ $? -eq 0 ]; then
    echo "Record inserted successfully into $TABLE_NAME table"
else
    echo "Error inserting record into $TABLE_NAME table"
fi