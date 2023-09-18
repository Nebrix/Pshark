# Pshark - Python Terminal Packet Sniffer
Pshark is a robust terminal-based packet sniffer coded in Python, providing powerful network analysis capabilities.

# Installation
Before using Pshark, make sure to install Npcap, a prerequisite for utilizing the scapy Python library. You can download and install Npcap from the official [Npcap website](https://npcap.com/).

# Getting Started
To harness the full potential of Pshark, follow these simple steps:

Clone the repository to your local machine:

```
git clone https://github.com/yourusername/pshark.git
```
Navigate to the project directory:

```
cd pshark
```
Run Pshark in your terminal:

```
python pshark.py
```

# Creating Executables
- Windows
  If you're using Windows, you can create an executable for Pshark by executing the following command in your terminal:
  ```
  .\build\build.ps1 windows
  ```
  This will generate a Windows executable that you can run without needing Python installed.

- Linux
  For Linux users, follow these steps to create a Linux executable:

  Open your terminal and navigate to the project directory:
  ```
  cd pshark
  ```
  Run the following command:

  ```
  ./build/build.ps1 linux
  ```
This will generate a Linux executable, allowing you to use Pshark on Linux systems without Python dependencies.

Pshark empowers you with comprehensive packet analysis tools, all from the convenience of your terminal. Start exploring and analyzing network packets with ease using Pshark
