from flask import Flask, request, jsonify
from flask_cors import CORS  # Flutterからのリクエストを許可する

app = Flask(__name__)
CORS(app)  # フロントエンドからのCORSリクエストを許可

@app.route("/api/hello", methods=["GET"])
def hello_api():
    return jsonify({"message": "hello from Flask"})

@app.route("/api/login", methods=["POST"])
def login_api():
    data = request.json
    username = data.get("username")
    password = data.get("password")

    if username == "admin" and password == "secret":
        return jsonify({"status": "success", "user": username})
    else:
        return jsonify({"status": "error", "message": "Invalid credentials"}), 401

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000, debug=True)
