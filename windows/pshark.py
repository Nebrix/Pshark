import sys
import psutil
import socket
from scapy.all import sniff


# user headers
from maintenance.update import update

def get_version_number():
    with open('version', 'r') as file:
        contents = file.read()

        for line in contents.split("\n"):
            key, value = line.split("=")

            if key.strip() == "VERSION":
                return value.strip()

    return None

def print_network_interfaces():
    interfaces = psutil.net_if_addrs()
    for interface, addresses in interfaces.items():
        print(f"Interface: {interface}")
        for address in addresses:
            print(f"  - Address: {address.address}")
            print(f"    Family: {address.family}")
            print(f"    Netmask: {address.netmask}")
            print(f"    Broadcast: {address.broadcast}")

def get_valid_network_interface():
    interfaces = psutil.net_if_addrs()
    valid_interfaces = [name for name, addrs in interfaces.items() if not any(socket.AF_INET in (addr.family, addr.address.startswith('127.')) for addr in addrs)]

    if valid_interfaces:
        return valid_interfaces[0]
    else:
        print("No valid network interface found.")
        return None

COMMANDS = {
    "start": lambda: sniff(iface=get_valid_network_interface(), prn=lambda x: x.summary()),
    "info": print_network_interfaces,
    "version": lambda: print(f"Current version: {get_version_number()}"),
    "update": lambda: update(),
    "quit": sys.exit,
    "help": lambda: print_help(),
}

def print_help():
    print("help:     Prints out this menu")
    print("start:    Starts the packet sniffer")
    print("version:  Prints out current version")
    print("update:   Updates the version Pshark")
    print("info:     Prints out all your network interfaces info")
    print("quit:     Quit app")

def main():
    if len(sys.argv) > 1 and sys.argv[1] == "/?":
        print_help()

    while True:
        userInput = input("> ")
        if userInput in COMMANDS:
            COMMANDS[userInput]()
        else:
            print("Invalid command. Use 'start' to begin sniffing or 'info' to get network information.")

if __name__ == "__main__":
    main()