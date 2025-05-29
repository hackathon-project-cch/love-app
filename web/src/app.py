import os
from flask import Flask, render_template, request, redirect, url_for
from werkzeug.utils import secure_filename
from google.cloud import vision
import io
import math

# Flask設定
app = Flask(
    __name__,
    template_folder="views",
    static_folder="views",
    static_url_path=""
)

# アップロード設定
UPLOAD_FOLDER = "uploads"
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024 * 1024  # 16MBまで

# Google Cloud Vision API 認証キー
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "your_key.json"  # ←ここは自分のキーに合わせて変更
client = vision.ImageAnnotatorClient()

# 距離を計算する関数
def distance(p1, p2):
    return math.sqrt((p1.x - p2.x)**2 + (p1.y - p2.y)**2)

@app.route("/", methods=["GET"])
def login_page():
    return render_template("login.html", title="ログイン")

@app.route("/upload", methods=["GET", "POST"])
def upload_file():
    result = None
    filename = None

    if request.method == "POST":
        file = request.files.get("image")
        if file and file.filename != "":
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config["UPLOAD_FOLDER"], filename)
            file.save(filepath)

            # Vision APIで顔分析
            with io.open(filepath, "rb") as image_file:
                content = image_file.read()
            image = vision.Image(content=content)
            response = client.face_detection(image=image)

            faces = response.face_annotations
            if not faces:
                result = "顔が検出されませんでした。"
            else:
                face = faces[0]
                landmarks = {lm.type_: lm.position for lm in face.landmarks}

                # パーツの距離を計算
                eye_dist = distance(landmarks['LEFT_EYE'], landmarks['RIGHT_EYE']) if 'LEFT_EYE' in landmarks and 'RIGHT_EYE' in landmarks else None
                eye_nose_dist = distance(landmarks['LEFT_EYE'], landmarks['NOSE_TIP']) if 'LEFT_EYE' in landmarks and 'NOSE_TIP' in landmarks else None

                result = {
                    "目と目の距離": f"{eye_dist:.2f} px" if eye_dist else "不明",
                    "目と鼻の距離": f"{eye_nose_dist:.2f} px" if eye_nose_dist else "不明",
                }

            return render_template("upload.html", filename=filename, result=result)

        else:
            return "ファイルが選択されていません"

    return render_template("upload.html")

@app.route("/dashboard", methods=["GET"])
def dashboard_page():
    return render_template("dashboard.html", user="Guest")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000, debug=True)