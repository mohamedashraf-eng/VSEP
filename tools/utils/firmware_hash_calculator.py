import logging
import os
from os import urandom
import argparse
#
import hashlib
from intelhex import IntelHex

# Configure logging
log_format = (
    "%(asctime)s - %(levelname)s - %(message)s - %(pathname)s:%(lineno)d - %(funcName)s"
)
logging.basicConfig(
                    level=logging.INFO, format=log_format)

class prj_foem_firmware:
    def __init__(self, firmware_fp):
        self.__firmware_hex_fp = firmware_fp
        self.__firmware_bin_fp = self.__firmware_hex_fp
        self.__firmware_size = None

    def __firmware_hex_fetch(self):
        try:
            with open(self.__firmware_hex_fp, "r") as hex_file:
                self.__firmware_hex.append(hex_file.readlines())
            logging.info(f"Fetched the hex file successfully.")
        except FileNotFoundError:
            logging.error(f"Error: File '{self.__firmware_hex_fp}' not found.")

    def __cvtHex2Bin(self, hex_fp):
        ih = IntelHex(hex_fp)

        ih.tobinfile("UpdatedFirmware.bin")
        self.__firmware_bin_fp = "./UpdatedFirmware.bin"
        
    @staticmethod
    def __calculate_sha256(fp__):
        sha256_hash = hashlib.sha256()
        with open(fp__, "rb") as f:
            # Read the file in chunks of 4096 bytes
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()
    
    def __firmware_calculate_size(self):
        try:
            with open(self.__firmware_bin_fp, "rb") as bin_fp:
                firmware_size = 0
                
                # Iterate through the binary file byte by byte
                byte = bin_fp.read(1)
                while byte:
                    firmware_size += 1
                    byte = bin_fp.read(1)
                
                self.__firmware_size = firmware_size
                return firmware_size
        except FileNotFoundError:
            logging.error(f"Error: File '{self.__firmware_bin_fp}' not found.")
            return None

    def run(self):
        self.__cvtHex2Bin(self.__firmware_hex_fp)
        print(f"Hash(SHA256): {self.__calculate_sha256(self.__firmware_hex_fp)}")
        print(f"Size(Bytes): {self.__firmware_calculate_size()}")
        #
        os.remove(self.__firmware_bin_fp)
        
if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-fp', '--file_path', type=str,
                        help='Specify the file path')
    args = parser.parse_args()
    file_path = args.file_path

    myFirmware = prj_foem_firmware(file_path)   
    myFirmware.run()
    