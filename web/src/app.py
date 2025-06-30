from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS, cross_origin  # CORS対応用のモジュール
from werkzeug.utils import secure_filename  # ファイル名を安全に処理するための関数
import os # OS操作のための標準モジュール
from faceai import faceSearch
from ControlDBAccess import getHairstyle  # ヘアスタイル取得のための関数をインポート
import tempfile

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
FLUTTER_WEB_DIR = os.path.join(BASE_DIR, 'my_web_app', 'build', 'web')

app = Flask(__name__, static_folder=FLUTTER_WEB_DIR, static_url_path='')

@app.route('/')
def home():
    return send_from_directory(app.static_folder, 'index.html')

# 任意のパスをすべてFlutterのbuild内から探すようにする
@app.route('/<path:path>')
def static_proxy(path):
    return send_from_directory(app.static_folder, path)

# FlaskのAPIエンドポイント（/api/get_hairstyleなど）はそのまま

# CORS（異なるオリジン間での通信）を許可
CORS(app)

# アップロードされたファイルを保存するフォルダのパス
UPLOAD_FOLDER = "uploads"

# アップロードフォルダが存在しない場合は作成
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

# ログインAPIエンドポイント
@app.route("/api/login", methods=["POST", "OPTIONS"])
@cross_origin()  # このエンドポイントに対してCORSを許可
def login_api():
    # プリフライトリクエスト（OPTIONS）の処理
    if request.method == "OPTIONS":
        return '', 200

    # クライアントから送られたJSONデータを取得
    data = request.json
    username = data.get("username")
    password = data.get("password")

    # ユーザー名とパスワードが一致するか確認
    if username == "admin" and password == "secret":
        return jsonify({"message": "Login success!"})  # 成功メッセージを返す
    else:
        return jsonify({"message": "Invalid credentials"}), 401  # 認証失敗（401エラー）

# ファイルアップロードAPIエンドポイント
@app.route("/api/upload", methods=["POST", "OPTIONS"])
@cross_origin()
def upload():
    global file_path
    if "file" not in request.files:
        return jsonify({"message": "No file part"}), 400

    file = request.files["file"]
    if file.filename == "":
        return jsonify({"message": "No selected file"}), 400

    filename = secure_filename(file.filename)
    
    # GCP対応：一時ディレクトリを使用
    temp_dir = tempfile.gettempdir()
    file_path = os.path.join(temp_dir, filename)
    file.save(file_path)

    print(f"✅ ファイルを保存しました: {file_path}")

    return jsonify({"message": "File uploaded", "path": file_path}), 200

#ローカルの場合はこっち
# def upload():
#     global file_path
#     # リクエストに"file"が含まれていない場合はエラー
#     if "file" not in request.files:
#         return jsonify({"message": "No file part"}), 400

#     # アップロードされたファイルを取得
#     file = request.files["file"]

#     # ファイルが空の場合の処理
#     if file.filename == "":
#         return jsonify({"message": "No selected file"}), 400

#     # 安全なファイル名に変換して保存パスを設定
#     filename = secure_filename(file.filename)
#     file_path = os.path.join(UPLOAD_FOLDER, filename)

#     # ファイルを保存
#     file.save(file_path)

#     # 保存完了のログ出力（ターミナルに表示）
#     print(f"✅ ファイルを保存しました: {file_path}")

#     # 成功レスポンスを返す
#     return jsonify({"message": "File uploaded"}), 200

@app.route("/api/get_sample_image", methods=["GET"])
@cross_origin()
def get_sample_image():
    try:
        face_shape = faceSearch(file_path)
        hairstyle, result_image_path = getHairstyle(face_shape)

        if hairstyle is None or result_image_path is None:
            return jsonify({
                "error": "指定された顔型に一致する髪型が見つかりませんでした。"
            }), 404

        full_url = request.host_url.rstrip('/') + '/static/' + result_image_path
        print(f"✅ 髪型: {hairstyle}, 画像パス: {result_image_path}")

        return jsonify({
            "image_url": full_url,
            "recommendation": f"あなたにおすすめの髪型は{hairstyle}です"
        })

    except Exception as e:
        print(f"❌ サーバーエラー: {str(e)}")
        return jsonify({"error": "サーバー内部でエラーが発生しました"}), 500


# アプリケーションのエントリーポイント
if __name__ == "__main__":
    # アプリを起動（ホスト0.0.0.0で外部アクセス可能、ポート3000）
    app.run(host="0.0.0.0", port=3000, debug=True)
