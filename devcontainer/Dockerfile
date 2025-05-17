# ベースは公式 DevContainers イメージ (Python + Node)
FROM mcr.microsoft.com/devcontainers/python:0-3.10

# Node 18 / yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && apt-get install -y nodejs && \
    npm install -g yarn

# Firebase CLI など追加ツールがあればここでインストール
