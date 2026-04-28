#!/bin/bash

echo "🚀 Bắt đầu khởi tạo project YOLOv8-Fish-Detection..."

# 1. Tạo cấu trúc thư mục chính
mkdir -p training/dataset
mkdir -p app/backend/core
mkdir -p app/backend/models
mkdir -p app/frontend/components
mkdir -p data/reports

# 2. Tạo file README và .gitignore
echo "# YOLOv8 Fish Detection System" > README.md
echo "venv/
__pycache__/
*.pt
*.onnx
.DS_Store
data/reports/*.csv
training/dataset/*" > .gitignore

# 3. Khởi tạo Backend (FastAPI)
cat <<EOF > app/backend/requirements.txt
fastapi
uvicorn
onnxruntime
opencv-python-headless
yt-dlp
pydantic
EOF

cat <<EOF > app/backend/main.py
from fastapi import FastAPI

app = FastAPI(title="Fish Detection API")

@app.get("/")
def read_root():
    return {"message": "Fish Detection Backend is running!"}

@app.post("/start_tank")
def start_tank(url: str):
    # Logic nạp URL và khởi chạy thread ONNX sẽ nằm ở đây
    return {"status": "started", "url": url}
EOF

cat <<EOF > app/backend/Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
EOF

# 4. Khởi tạo Frontend (Streamlit)
cat <<EOF > app/frontend/requirements.txt
streamlit
requests
pandas
plotly
EOF

cat <<EOF > app/frontend/app.py
import streamlit as st
import requests

st.set_page_config(page_title="Bể Cá Online", layout="wide")
st.title("🐠 Hệ Thống Đếm Cá Thời Gian Thực")

st.sidebar.header("Cấu hình Bể cá")
youtube_url = st.sidebar.text_input("Nhập YouTube URL Livestream:")

if st.sidebar.button("Khởi động"):
    st.success(f"Đã nạp luồng: {youtube_url}")
    # Gọi API backend tại đây trong các bước tới
EOF

cat <<EOF > app/frontend/Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
EOF

# 5. Khởi tạo Docker Compose
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  backend:
    build: ./app/backend
    ports:
      - "8000:8000"
    volumes:
      - ./app/backend:/app
      - ./data:/data

  frontend:
    build: ./app/frontend
    ports:
      - "8501:8501"
    volumes:
      - ./app/frontend:/app
    depends_on:
      - backend
EOF

# 6. Tạo file rỗng cho phần training
touch training/export_onnx.py
touch training/yolov8_finetune.ipynb

echo "✅ Đã tạo xong toàn bộ cấu trúc dự án!"
echo "📂 Vui lòng kiểm tra các thư mục bên thanh Explorer."