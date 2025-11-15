#!/bin/bash
# Teddy Server Network Installer Script

# Exit on any error
set -e

echo "Starting Teddy Server Installation..."

# 1. Download Source
echo "Cloning source repository..."
git clone https://github.com/rushikesh648/Keto.git teddy-server
cd teddy-server

# 2. Install Dependencies
echo "Installing NASM (Netwide Assembler)..."
sudo apt update
sudo apt install nasm -y

# 3. Create/Replace the Assembly Server File (Manual step for the user)
echo "NOTE: Please ensure 'teddy_server.asm' with the network code is in this directory."

# 4. Build the Server
echo "Building Teddy Server binary..."
nasm -f elf64 teddy_server.asm -o teddy_server.o
ld teddy_server.o -o teddy_server

echo "Installation complete. Run the server using: ./teddy_server"
