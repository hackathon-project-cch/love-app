from flask import Flask, request, jsonify
from flask_cors import CORS, cross_origin
from werkzeug.utils import secure_filename
import os

app = Flask(__name__)
CORS(app)  # もしくは後述の cross_origin を各エンドポイントに

UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route("/api/login", methods=["POST", "OPTIONS"])
@cross_origin()  # ← これを追加
def login_api():
    if request.method == "OPTIONS":
        return '', 200

    data = request.json
    username = data.get("username")
    password = data.get("password")

    if username == "admin" and password == "secret":
        return jsonify({"message": "Login success!"})
    else:
        return jsonify({"message": "Invalid credentials"}), 401


@app.route("/api/upload", methods=["POST", "OPTIONS"])
@cross_origin()  # ← これも追加
def upload():
    if "file" not in request.files:
        return jsonify({"message": "No file part"}), 400

    file = request.files["file"]
    if file.filename == "":
        return jsonify({"message": "No selected file"}), 400

    filename = secure_filename(file.filename)
    file_path = os.path.join(UPLOAD_FOLDER, filename)
    file.save(file_path)

    print(f"✅ ファイルを保存しました: {file_path}")
    return jsonify({"message": "File uploaded"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000, debug=True)
