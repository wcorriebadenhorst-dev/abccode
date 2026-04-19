#!/bin/bash

echo "=============================="
echo "   GPU Share - Setup Script"
echo "=============================="

# 1. Install system dependencies
echo "[1] Installing system dependencies..."
sudo apt install -y curl python3 python3-venv python3-tk nodejs npm

# 2. Install Rust
echo "[2] Installing Rust..."
if ! command -v rustc &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
else
    echo "Rust already installed: $(rustc --version)"
fi

# 3. Set up Python virtual environment
echo "[3] Setting up Python environment..."
cd ~/AbcCode/gpu-share
python3 -m venv venv
source venv/bin/activate
pip install flask

# 4. Build Rust server
echo "[4] Building Rust server..."
cd ~/AbcCode/gpu-share/rust-host
cargo build

# 5. Install Electron dependencies
echo "[5] Installing Electron..."
cd ~/AbcCode/gpu-share/electron-app
npm install

# 6. Fix Electron sandbox
echo "[6] Fixing Electron sandbox permissions..."
sudo chown root:root node_modules/electron/dist/chrome-sandbox
sudo chmod 4755 node_modules/electron/dist/chrome-sandbox


echo "[7] Fixing Electron sandbox permissions..."
cargo add vulkano

echo ""
echo "=============================="
echo "   Setup Complete!"
echo "   Run: bash run.sh to start"
echo "=============================="