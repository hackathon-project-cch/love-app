# api/src/app.py
import os
from flask import Flask, jsonify, request
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

load_dotenv()  # .env から DB_* を読み込む

app = Flask(__name__)

# SQLAlchemy で DB 接続（Flask-SQLAlchemy を入れてもOK）
DB_URL = f"postgresql://{os.getenv('DB_USER')}:{os.getenv('DB_PASS')}@" \
         f"{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
engine = create_engine(DB_URL, future=True)

@app.route("/api/hello", methods=["GET"])
def hello():
    return jsonify(message="hello from Flask!")

@app.route("/api/users", methods=["GET"])
def list_users():
    with engine.connect() as conn:
        rs = conn.execute(text("SELECT id, username FROM users"))
        users = [dict(r) for r in rs]
    return jsonify(users=users)

# ここに必要な Controller を追加…

if __name__ == "__main__":
    # 開発用サーバー
    app.run(host="0.0.0.0", port=int(os.getenv("API_PORT", 8000)), debug=True)
