from flask import Flask, render_template, jsonify
import subprocess
import threading
import os
import signal

app = Flask(__name__, template_folder="web-ui")

process = None
logs = []

def stream_output(proc):
    for line in iter(proc.stdout.readline, b""):
        logs.append(line.decode().strip())

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/start", methods=["POST"])
def start():
    global process
    if process is not None:
        return jsonify({"status": "already running"})
    binary = "./rust-host/target/debug/rust-host"
    if not os.path.exists(binary):
        return jsonify({"status": "binary not found"})
    process = subprocess.Popen(
        [binary],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    t = threading.Thread(target=stream_output, args=(process,), daemon=True)
    t.start()
    return jsonify({"status": "started"})

@app.route("/stop", methods=["POST"])
def stop():
    global process
    if process is None:
        return jsonify({"status": "not running"})
    os.kill(process.pid, signal.SIGTERM)
    process = None
    return jsonify({"status": "stopped"})

@app.route("/logs")
def get_logs():
    return jsonify({"logs": logs})

if __name__ == "__main__":
    app.run(debug=True, port=5000)