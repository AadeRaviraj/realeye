from astrapy import DataAPIClient
from app.config import Config
import requests
import time
import datetime
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("AIService")

# Astra DB
client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)

users_collection = db.get_collection("users")
chat_collection = db.get_collection("chat_history")

# Groq
GROQ_API_KEY = Config.GROQ_API_KEY
if not GROQ_API_KEY:
    raise ValueError("GROQ_API_KEY missing!")


# --------------------------------------------------------
# USER
# --------------------------------------------------------
def get_user(user_id):
    user = users_collection.find_one({"user_id": user_id})

    if not user:
        user = {
            "user_id": user_id,
            "is_pro": False,
            "daily_count": 0,
            "last_reset": str(datetime.date.today())
        }
        users_collection.insert_one(user)

    return user


def update_user(user_id, data):
    users_collection.update_one(
        {"user_id": user_id},
        {"$set": data}
    )


# --------------------------------------------------------
# SAVE MESSAGE
# --------------------------------------------------------
def save_message(user_id, question, answer):
    try:
        chat_collection.insert_one({
            "user_id": user_id,
            "question": question,
            "answer": answer,
            "created_at": int(time.time() * 1000)
        })
    except Exception as e:
        logger.error(f"Save error: {e}")


# --------------------------------------------------------
# GET HISTORY
# --------------------------------------------------------
def get_chat_history(user_id):
    try:
        messages = list(chat_collection.find(
            {"user_id": user_id},
            sort={"created_at": 1}
        ))

        history = []
        for msg in messages:
            history.append({
                "question": msg.get("question"),
                "answer": msg.get("answer")
            })

        return history

    except Exception as e:
        logger.error(f"History error: {e}")
        return []


# --------------------------------------------------------
# GROQ CALL
# --------------------------------------------------------
def call_groq(prompt):
    url = "https://api.groq.com/openai/v1/chat/completions"

    headers = {
        "Authorization": f"Bearer {GROQ_API_KEY}",
        "Content-Type": "application/json"
    }

    data = {
        "model": "llama-3.1-8b-instant",
        "messages": [
            {
                "role": "system",
                "content": "You are an interview preparation assistant. Answer clearly with simple explanations and examples."
            },
            {
                "role": "user",
                "content": prompt
            }
        ]
    }

    try:
        response = requests.post(url, headers=headers, json=data, timeout=10)

        if response.status_code == 200:
            result = response.json()
            return result["choices"][0]["message"]["content"]

        return "Error generating response."

    except Exception as e:
        logger.error(f"Groq error: {e}")
        return "Service unavailable."


# --------------------------------------------------------
# MAIN LOGIC
# --------------------------------------------------------
def get_ai_response(user_id, prompt):
    user = get_user(user_id)

    today = str(datetime.date.today())
    if user.get("last_reset") != today:
        user["daily_count"] = 0
        user["last_reset"] = today

    if not user["is_pro"] and user["daily_count"] >= 5:
        return {"status": "LIMIT_EXCEEDED"}

    reply = call_groq(prompt)

    save_message(user_id, prompt, reply)

    user["daily_count"] += 1
    update_user(user_id, user)

    remaining = max(0, 5 - user["daily_count"])

    return {
        "status": "OK",
        "response": reply,
        "remaining": remaining
    }