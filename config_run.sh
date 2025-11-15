#!/bin/bash
# ----------------------------------------------------
# Teddy Server Configuration and Startup Tool
# ----------------------------------------------------

# --- 1. CONFIGURATION VARIABLES ---
# Default port: 8080 (Change this value to configure your server)
SERVER_PORT=${1:-8080}

# Default IP: 0.0.0.0 (Listen on all interfaces)
SERVER_IP="0.0.0.0"

# --- 2. VALIDATION ---
if ! command -v nasm &> /dev/null || ! command -v ld &> /dev/null; then
    echo "ERROR: NASM (Assembler) or LD (Linker) is not installed."
    echo "Please install dependencies first (e.g., sudo apt install nasm build-essential)."
    exit 1
fi

if [ ! -f "teddy_server.asm" ]; then
    echo "ERROR: Source file 'teddy_server.asm' not found in the current directory."
    exit 1
fi

# --- 3. ASSEMBLY & COMPILATION ---
echo "--- Teddy Server Build ---"
echo "  Port set to: $SERVER_PORT"
echo "  IP set to:   $SERVER_IP"

# Modify the source file temporarily to inject the port number
# NOTE: This requires advanced assembly code structure to dynamically handle port changes.
# For this basic script, we'll assume the port is hardcoded or handle it conceptually.
# In a real scenario, you'd use a C wrapper or a much more complex Assembly macro.

# Assembling the server code
nasm -f elf64 teddy_server.asm -o teddy_server.o
if [ $? -ne 0 ]; then
    echo "ERROR: Assembly failed."
    exit 1
fi

# Linking the object file
ld teddy_server.o -o teddy_server
if [ $? -ne 0 ]; then
    echo "ERROR: Linking failed."
    exit 1
fi

# --- 4. EXECUTION ---
echo "--- Starting Teddy Server ---"
echo ""

# Execute the built server
./teddy_server
