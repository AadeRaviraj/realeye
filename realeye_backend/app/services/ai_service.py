# from cassandra.cluster import Cluster
# from cassandra.auth import PlainTextAuthProvider
# import requests
# from app import config

# cloud_config = {'secure_connect_bundle': 'realeye_token.json'}
# auth_provider = PlainTextAuthProvider('token', config.ASTRA_DB_TOKEN)
# cluster = Cluster(cloud=cloud_config, auth_provider=auth_provider)
# session = cluster.connect(config.ASTRA_DB_KEYSPACE)

# # Create chat_history table if not exists
# session.execute("""
# CREATE TABLE IF NOT EXISTS chat_history (
#   user_id text,
#   created_at timestamp,
#   sender text,
#   message text,
#   PRIMARY KEY (user_id, created_at)
# ) WITH CLUSTERING ORDER BY (created_at ASC);
# """)

# headers = {"Authorization": f"Bearer {config.HF_API_TOKEN}"}
# HF_API_URL = f"https://api-inference.huggingface.co/models/{config.HF_MODEL}"

# def query_huggingface(prompt):
#     payload = {"inputs": prompt}
#     response = requests.post(HF_API_URL, headers=headers, json=payload)
#     if response.status_code == 200:
#         data = response.json()
#         if isinstance(data, list) and len(data) > 0:
#             return data[0]['generated_text']
#     return "I'm sorry, I couldn’t process that."

# def save_message(user_id, sender, message):
#     session.execute(
#         "INSERT INTO chat_history (user_id, created_at, sender, message) VALUES (%s, toTimestamp(now()), %s, %s)",
#         (user_id, sender, message)
#     )

# def get_chat_history(user_id, limit=100):
#     rows = session.execute(
#         "SELECT * FROM chat_history WHERE user_id=%s LIMIT %s",
#         (user_id, limit)
#     )
#     return [{"sender": r.sender, "message": r.message, "created_at": str(r.created_at)} for r in rows]




# app/services/ai_service.py
from astrapy import DataAPIClient
from app.config import Config
import requests
import os

# --- Astra DB (Data API) connection ---
if not Config.ASTRA_DB_APPLICATION_TOKEN or not Config.ASTRA_DB_API_ENDPOINT:
    raise RuntimeError("ASTRA_DB_APPLICATION_TOKEN or ASTRA_DB_API_ENDPOINT missing in environment")

client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)
chat_collection = db.get_collection("chat_history")

# --- Save message ---
def save_message(user_id, message, sender):
    if user_id is None:
        user_id = "anonymous"
    chat_collection.insert_one({
        "user_id": user_id,
        "message": message,
        "sender": sender
    })

# --- Get user chat history ---
def get_chat_history(user_id, limit=100):
    if user_id is None:
        return []
    cursor = chat_collection.find({"user_id": user_id}, limit=limit)
    # astrapy returns iterable; convert to list of dicts
    docs = list(cursor)
    # normalize fields for JSON
    out = []
    for d in docs:
        out.append({
            "sender": d.get("sender"),
            "message": d.get("message"),
            "id": str(d.get("_id")) if d.get("_id") else None
        })
    return out

# --- Query Hugging Face (DialoGPT-medium) ---
def query_huggingface(prompt):
    hf_token = Config.HUGGINGFACE_API_TOKEN
    model = Config.HF_MODEL
    if not hf_token:
        # fallback simple reply
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
        result = resp.json()
        # HF often returns list with generated_text
        if isinstance(result, list) and len(result) > 0 and "generated_text" in result[0]:
            return result[0]["generated_text"]
        # fallback if dict contains generated_text
        if isinstance(result, dict) and "generated_text" in result:
            return result["generated_text"]
        # else convert to string
        return str(result)
    except Exception as e:
        print("Hugging Face error:", e)
        return "Sorry — I couldn't generate a response right now."
