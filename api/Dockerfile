FROM python:3.10-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY api/src/ ./src
ENV PYTHONUNBUFFERED=1
ENV PORT=${API_PORT:-8000}
EXPOSE ${PORT}
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:8000", "src.app:app"]
