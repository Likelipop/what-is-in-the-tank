import streamlit as st
import requests

st.set_page_config(page_title="Bể Cá Online", layout="wide")
st.title("🐠 Hệ Thống Đếm Cá Thời Gian Thực")

st.sidebar.header("Cấu hình Bể cá")
youtube_url = st.sidebar.text_input("Nhập YouTube URL Livestream:")

if st.sidebar.button("Khởi động"):
    st.success(f"Đã nạp luồng: {youtube_url}")
    # Gọi API backend tại đây trong các bước tới
