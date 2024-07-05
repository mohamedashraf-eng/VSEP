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
FIRMWARE_DIR="~/Documents/GP/Grad_Project/src/oem_intf/django_webappv1/fota/firmwares/"
HASH_FILE_PATH="~/Documents/CMAKE_GP/website/fota/firmwares/UpdatedFirmwareHash.txt"
IS_ACTIVE=1
DESCRIPTION=""

# Expand paths
OLD_FIRMWARE_FILE=$(eval echo $OLD_FIRMWARE_FILE)
FIRMWARE_DIR=$(eval echo $FIRMWARE_DIR)
HASH_FILE_PATH=$(eval echo $HASH_FILE_PATH)

# Define the maximum length for the firmware field in the database
MAX_FIRMWARE_PATH_LENGTH=255  # Example: adjust this based on your schema

# Counter file path
COUNTER_FILE="${FIRMWARE_DIR}firmware_counter.txt"

# Initialize counter file if it doesn't exist
if [[ ! -f $COUNTER_FILE ]]; then
    echo "0" > "$COUNTER_FILE"
fi

# Read the current counter value
COUNTER=$(cat "$COUNTER_FILE")

# Increment the counter
NEW_COUNTER=$((COUNTER + 1))

# Convert the counter to a base-36 string (to include digits and letters)
FIRMWARE_SUFFIX=$(printf "%02s" $(echo "obase=36; $NEW_COUNTER" | bc) | tr ' ' '0')

# Create the new firmware file name
NEW_FIRMWARE_FILE="UF_${FIRMWARE_SUFFIX}.hex"

# Calculate the total length of the firmware file path
NEW_FIRMWARE_FILE_LENGTH=${#NEW_FIRMWARE_FILE}
FIRMWARE_DIR_LENGTH=${#FIRMWARE_DIR}
TOTAL_LENGTH=$((FIRMWARE_DIR_LENGTH + NEW_FIRMWARE_FILE_LENGTH))

if [ $TOTAL_LENGTH -gt $MAX_FIRMWARE_PATH_LENGTH ]; then
    # Calculate the maximum allowed length for the firmware file name
    MAX_FILENAME_LENGTH=$((MAX_FIRMWARE_PATH_LENGTH - FIRMWARE_DIR_LENGTH))
    # Truncate the new firmware file name if necessary
    NEW_FIRMWARE_FILE=$(echo $NEW_FIRMWARE_FILE | cut -c 1-$MAX_FILENAME_LENGTH)
fi

# Full path for the new firmware file
NEW_FIRMWARE_PATH="${FIRMWARE_DIR}${NEW_FIRMWARE_FILE}"

# Update the counter file with the new counter value
echo "$NEW_COUNTER" > "$COUNTER_FILE"

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
cp "$OLD_FIRMWARE_FILE" "$NEW_FIRMWARE_PATH"

# MySQL command to insert a new record
INSERT_QUERY="INSERT INTO $TABLE_NAME (version, release_date, firmware, is_active, firmware_cmac, firmware_size, description) VALUES ('$VERSION', '$RELEASE_DATE', '$NEW_FIRMWARE_PATH', $IS_ACTIVE, '$firmware_hash', '$firmware_size', '$DESCRIPTION');"

# Execute the MySQL command
mysql -u"$DB_USER" -h "$DB_HOST" -D "$DB_NAME" -e "$INSERT_QUERY"

if [ $? -eq 0 ]; then
    echo "Record inserted successfully into $TABLE_NAME table"
else
    echo "Error inserting record into $TABLE_NAME table"
fi
