# ハッカソンローカル開発環境セットアップ手順


## 0. 前提ソフトウェア

| ツール                | 目安バージョン  | 入手先                                                                                              |
| ------------------ | -------- | ------------------------------------------------------------------------------------------------ |
| **Git**            | 2.40 以上  | [https://git-scm.com/](https://git-scm.com/)                                                     |
| **Python**         | 3.10 系推奨 | [https://www.python.org/](https://www.python.org/)                                               |
| **Docker Desktop** | 最新安定版    | [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop) |

---

## 1. リポジトリ取得
好きなディレクトリに移動し、以下のコマンドを実行してください。
実行後に、love-appという名前のフォルダが出来るので、VScodeで開いてください。

```bash
git clone https://github.com/hackathon-project-cch/love-app.git
```
---

## 2. `.env` ファイルを用意
以下のコマンドを実行して、.envファイルを作成して下さい。中身は必要に応じて変更してください。
```bash
cp .env.example .env
```

---

## 3. Python 仮想環境 (venv) を作成して依存を入れる
以下のコマンドを実行して、venvの仮想環境を作成し、その中にライブラリなどをrequirements.txtからインストールしましょう。
### macOS / Linux

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

### Windows (PowerShell)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force  # スクリプト一時許可
python -m venv .venv
. .venv\Scripts\Activate.ps1
pip install --upgrade pip
pip install -r requirements.txt
```

> venv を抜けるときは `deactivate`。
---

## 4. サービスの起動（run.sh で一括）

開発サーバー群（db / nginx / web / api）はすべて run.sh にまとめてあります。ホスト OS でも venv 有効化後でも、以下 1 行で OK です。

```bash
# 起動（ビルド込み）
./run.sh start

# ログを見る
./run.sh logs

# 停止
./run.sh stop
```

ブラウザ確認:

* Web → [http://localhost](http://localhost)
* API(まだアクセスしても何もない) → [http://localhost:8000](http://localhost:8000)


---

## 6. フォルダー構成と役割
今後もっと詳しく追加予定…

```
love-app/
├─ web/                # UI レイヤ（Flask／テンプレート）
│  └─ src/
│     ├─ app.py        # / と /login など画面ルーティング
│     └─ views/        # 静的アセット
│         └─ login.html
│
├─ api/                # バックエンド API（Flask + Gunicorn）
│  └─ src/
│     ├─ app.py        # /api/ エンドポイント登録
│     └─ controllers/  # DBを操作するAPI
│
├─ scripts/            # DB マイグレーション／データ投入
│  ├─ migrate.sh
│  └─ seed.sh
│
├─ docker-compose.yml  # db・nginx を束ねる
├─ requirements.txt    # Python 依存ライブラリ（共通）
├─ .env                # 環境変数（ポート／DB 認証など）
└─ run.sh              # 開発環境立ち上げスクリプト
```

---

## 7. Git 運用ルール（Develop 起点）
今後操作方法などもっと詳しく説明予定…
**なので自信ない人はブランチ作らないでください！**

```bash
# 1) 最新 develop を取得
git checkout develop && git pull

# 2) 個人ブランチを切る
git switch -c feature/<yourname>/<topic>

# 3) コードを書いて動作確認（./run.sh start → ブラウザ確認）

# 4) コミット & プッシュ
git add .
git commit -m "〇〇機能実装"
git push -u origin feature/<yourname>/<topic>

# 5) GitHub で PR を develop へ → レビュー → Squash Merge

# 6) 最新 develop を pull
git checkout develop && git pull
```

> **原則** : `main` へ直接 push しない。常に `feature → develop → main` の順で統合します。

---

## 8. よくあるトラブルシューティング

| 症状                            | 対処                                                                 |
| ----------------------------- | ------------------------------------------------------------------ |
| VScodeのターミナル で `.venv` が有効化できない | `Set-ExecutionPolicy Bypass -Scope Process` を実行                    |
| Port 3306 が既に使われている           | `.env` の `DB_PORT` を 3307 など空きポートに変更し `docker compose up -d db`    |
| 依存追加したのに反映されない                | `pip install -r requirements.txt` を再実行／`docker compose up -d` をし直す |

---

これでローカル venv + Docker の開発環境を誰でも再現できます。困ったら #質問 まで！
