#!/bin/bash

# Database credentials
DB_USER="root"
DB_PASS=""
DB_HOST="localhost"
DB_NAME="myFOTA"
TABLE_NAME="website_fota_firmware"

# Firmware details
VERSION=$1
RELEASE_DATE="2024-06-29"
OLD_FIRMWARE_FILE="~/Documents/CMAKE_GP/website/fota/firmwares/UpdatedFirmware.hex"
FIRMWARE_DIR="~/Documents/GP/Grad_Project/src/oem_intf/django_webappv1/fota/firmwares"
HASH_FILE_PATH="~/Documents/CMAKE_GP/website/fota/firmwares/UpdatedFirmwareHash.txt"
IS_ACTIVE=1
DESCRIPTION=""

# Expand paths
OLD_FIRMWARE_FILE=$(eval echo $OLD_FIRMWARE_FILE)
FIRMWARE_DIR=$(eval echo $FIRMWARE_DIR)
HASH_FILE_PATH=$(eval echo $HASH_FILE_PATH)

# Generate a random hash for the new firmware file name
RANDOM_HASH=$(openssl rand -hex 16)
NEW_FIRMWARE_FILE="${FIRMWARE_DIR}/UpdatedFirmware_${RANDOM_HASH}.hex"

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

# Copy the old firmware file to the new location with the new filename
cp "$OLD_FIRMWARE_FILE" "$NEW_FIRMWARE_FILE"

# MySQL command to insert a new record
INSERT_QUERY="INSERT INTO $TABLE_NAME (version, release_date, firmware, is_active, firmware_cmac, firmware_size, description) VALUES ('$VERSION', '$RELEASE_DATE', '$NEW_FIRMWARE_FILE', $IS_ACTIVE, '$firmware_hash', '$firmware_size', '$DESCRIPTION');"

# Execute the MySQL command
mysql -u"$DB_USER" -h "$DB_HOST" -D "$DB_NAME" -e "$INSERT_QUERY"

if [ $? -eq 0 ]; then
    echo "Record inserted successfully into $TABLE_NAME table"
else
    echo "Error inserting record into $TABLE_NAME table"
fi
