import os
from flask import Flask, render_template, request, redirect, url_for
from dotenv import load_dotenv

load_dotenv()

WEB_PORT = int(os.getenv("WEB_PORT", 3000))

app = Flask(
    __name__,
    # どこをテンプレート（HTML）として読むか
    template_folder="views",
    # どこを静的ファイル（CSS/画像等）として公開するか
    static_folder="views",
    # 静的ファイルはルート直下 (/style.css) にマウント
    static_url_path=""
)

@app.route("/", methods=["GET"])
def login_page():
    return render_template("login.html", title="ログイン")

@app.route("/login", methods=["POST"])
def do_login():
    # 認証処理…
    return redirect(url_for("dashboard_page"))

@app.route("/dashboard", methods=["GET"])
def dashboard_page():
    return render_template("dashboard.html", user="Guest")

@app.route("/api/hello", methods=["GET"])
def hello_api():
    return {"message": "hello from Web-Flask"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=WEB_PORT, debug=True)
