# api/src/app.py
import os
from flask import Flask, jsonify, request
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

load_dotenv()                # .env から DB_* と API_PORT をロード
app = Flask(__name__)

# ── MySQL 用の接続 URI ──
DB_URL = (
    f"mysql+pymysql://{os.getenv('DB_USER')}:{os.getenv('DB_PASS')}"
    f"@{os.getenv('DB_HOST')}:{os.getenv('DB_PORT')}/{os.getenv('DB_NAME')}"
)
engine = create_engine(DB_URL, future=True)

# ── ルート定義 ──
@app.route("/api/hello", methods=["GET"])
def hello():
    return jsonify(message="hello from Flask!")

@app.route("/api/users", methods=["GET"])
def list_users():
    with engine.connect() as conn:
        rs = conn.execute(text("SELECT id, username FROM users"))
        users = [dict(r) for r in rs]
    return jsonify(users=users)

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=int(os.getenv("API_PORT", 8000)),
        debug=True
    )
