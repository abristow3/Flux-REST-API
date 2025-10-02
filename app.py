from flask import Flask, jsonify, request
from flask_cors import CORS
import json
import os

app = Flask(__name__)
CORS(app)  # Allow all origins by default

CONFIG_FILE_PATH = '/app/config.json'  # Path inside the Docker container

# Ensure config file exists
if not os.path.exists(CONFIG_FILE_PATH):
    with open(CONFIG_FILE_PATH, 'w') as f:
        json.dump({}, f)

@app.route('/read-config', methods=['GET'])
def read_config():
    try:
        with open(CONFIG_FILE_PATH, 'r') as f:
            data = json.load(f)
        return jsonify(data), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/write-config', methods=['POST'])
def write_config():
    try:
        update_data = request.json
        with open(CONFIG_FILE_PATH, 'r') as f:
            current = json.load(f)
        current.update(update_data)
        with open(CONFIG_FILE_PATH, 'w') as f:
            json.dump(current, f, indent=4)
        return jsonify({"message": "Config updated"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
