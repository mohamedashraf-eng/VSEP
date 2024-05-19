import serial
import serial.tools.list_ports

def start_app_procedure(ser):
    ser.write(b'S')

def stop_app_procedure(ser):
    ser.write(b's') 

if __name__ == '__main__':
    port = '/dev/ttyUSB0'
    if port:
        try:
            with serial.Serial(port, baudrate=115200, timeout=1) as ser:
                while True:
                    try:
                        print("Commands:")
                        print(" [1] Start procedure")
                        print(" [2] Stop procedure")
                        print(" [3] Quit")

                        command = input("Enter command: ").strip()
                        
                        if command == '1':
                            start_app_procedure(ser)
                        
                        elif command == '2':
                            stop_app_procedure(ser)
                        
                        elif command == '3':
                            break
                        
                        else:
                            print("Invalid command")
                            
                    except KeyboardInterrupt:
                        print("Exited")
        except Exception as e:
            if e is KeyboardInterrupt:
                print("Exited")
            else:
                print(f"Failed to connect to port {port}")
                print(f"Error: {e}")
    else:
        print("UART device not found.")
