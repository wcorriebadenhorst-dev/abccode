#!/bin/bash

echo "[*] Starting GPU Share..."

# Start Flask using the venv Python directly
cd ~/AbcCode/gpu-share
~/AbcCode/gpu-share/venv/bin/python3 app.py &
FLASK_PID=$!
echo "[+] Flask started (PID: $FLASK_PID)"

# Wait for Flask to be ready
sleep 2

# Start Electron
cd ~/AbcCode/gpu-share/electron-app
npm start

# When Electron closes, kill Flask
echo "[*] Shutting down Flask..."
kill $FLASK_PID