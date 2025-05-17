FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY web/src /app/src
WORKDIR /app/src
ENV FLASK_ENV=development
ENV FLASK_DEBUG=1
ENV FLASK_APP=app.py
ENV WEB_PORT=${WEB_PORT:-3000}
EXPOSE ${WEB_PORT}
CMD ["sh", "-c", "flask run --host=0.0.0.0 --port $WEB_PORT"]
