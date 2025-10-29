# app/services/ai_service.py
from astrapy import DataAPIClient
from app.config import Config
import requests, time

# Validate env vars
if not Config.ASTRA_DB_APPLICATION_TOKEN or not Config.ASTRA_DB_API_ENDPOINT:
    raise RuntimeError("ASTRA_DB_APPLICATION_TOKEN or ASTRA_DB_API_ENDPOINT missing in environment")

# Astra Data API client
client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)

# get (or create implicitly) a collection named chat_history
# chat_collection = db.get_collection("chat_history")
collection_name = "chat_history"

try:
    chat_collection = db.get_collection(collection_name)
except Exception as e:
    print(f"Collection '{collection_name}' not found. Creating it now...")
    db.create_collection(collection_name)
    chat_collection = db.get_collection(collection_name)

def save_message(user_id, message, sender):
    if user_id is None:
        user_id = "anonymous"
    doc = {
        "user_id": user_id,
        "message": message,
        "sender": sender,
        "created_at": int(time.time() * 1000)  # store as epoch ms
    }
    chat_collection.insert_one(doc)
    return doc

def get_chat_history(user_id, limit=100):
    if not user_id:
        return []
    cursor = chat_collection.find({"user_id": user_id}, limit=limit)
    docs = list(cursor)
    # normalize for JSON (astrapy returns dict-like objects)
    return [{"sender": d.get("sender"), "message": d.get("message"), "created_at": d.get("created_at")} for d in docs]

# Hugging Face call
def query_huggingface(prompt):
    hf_token = Config.HUGGINGFACE_API_TOKEN
    model = Config.HF_MODEL
    if not hf_token:
        # fallback: dummy
        return f"AI (local): I received: '{prompt}'"
    url = f"https://api-inference.huggingface.co/models/{model}"
    headers = {"Authorization": f"Bearer {hf_token}", "Content-Type": "application/json"}
    payload = {
        "inputs": prompt,
        "parameters": {"temperature": 0.7, "top_p": 0.9, "max_new_tokens": 120},
        "options": {"wait_for_model": True}
    }
    try:
        resp = requests.post(url, headers=headers, json=payload, timeout=30)
        resp.raise_for_status()
        data = resp.json()
        # often HF returns list with 'generated_text' in index 0
        if isinstance(data, list) and len(data) > 0 and "generated_text" in data[0]:
            return data[0]["generated_text"]
        if isinstance(data, dict) and "generated_text" in data:
            return data["generated_text"]
        return str(data)
    except Exception as e:
        print("HF error:", e)
        return "Sorry, I couldn't generate a reply right now."
