Welcome to the love-app wiki!
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
**開発を行う時は必ず仮想環境に入ってから作業をしよう！**
> venv を抜けるときは `deactivate`。
---

## 4. サービスの起動（run.sh で一括）

開発サーバー群（db / nginx / web / api）はすべて run.sh にまとめてあります。ホスト OS でも venv 有効化後でも、以下 1 行で OK です。


### Docker Desktopを立ち上げる
特にノリカス

### 仮想環境に入る
```bash
. .venv\Scripts\Activate.ps1
```

### 起動
```bash
docker compose up -d --build
```

### ログを見る
```bash
docker compose ps
```

### 停止
```bash
docker compose down
```

ブラウザ確認:

* Web → [http://localhost](http://localhost)
* API(まだアクセスしても何もない) → [http://localhost:8000](http://localhost:8000)

* もしURLを開いても何も表示されなかったら、以下のコマンドを実行して、サーバーが4つ起動しているか確認してください。もし起動していなかったら#質問チャンネルまで！
```bash
docker compose ps
```
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
 # ──【1. 作業ブランチを最新化して作業＋プッシュ】─────────────
  git fetch origin
  git checkout Dev-kota
  git merge origin/develop           # develop の最新を取り込む
　git push origin Dev-kota           # リモートにプッシュ
  # …ここでコーディング作業
  git add .                          # 変更をステージ
  git commit -m "コメント"            # 作業内容をコミット
  git push origin Dev-kota           # リモートにプッシュ

  # ──【2. develop へ切り替え＆プルリクエスト】────────────────────────
  GitHub上からプルリクエストを作成(create pull request)
  into Dev-kota → from Developで経路を指定
  @reiyaに承認してもらってください
```

> **原則** : `main` へ直接 push しない。プッシュする時は必ずブランチを確認！！

---


これでローカル venv + Docker の開発環境を誰でも再現できます。困ったら #質問 まで！
