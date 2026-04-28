from fastapi import FastAPI

app = FastAPI(title="Fish Detection API")

@app.get("/")
def read_root():
    return {"message": "Fish Detection Backend is running!"}

@app.post("/start_tank")
def start_tank(url: str):
    # Logic nạp URL và khởi chạy thread ONNX sẽ nằm ở đây
    return {"status": "started", "url": url}
