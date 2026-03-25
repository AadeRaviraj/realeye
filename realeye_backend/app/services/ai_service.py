from astrapy import DataAPIClient
from app.config import Config
import requests
import time
import datetime
import logging

# --------------------------------------------------------
# Logging
# --------------------------------------------------------
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("AIService")

# --------------------------------------------------------
# Astra DB Setup
# --------------------------------------------------------
client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)

# Collections
users_collection = db.get_collection("users")
chat_collection = db.get_collection("chat_history")

# --------------------------------------------------------
# Groq API Setup
# --------------------------------------------------------
GROQ_API_KEY = Config.GROQ_API_KEY

if not GROQ_API_KEY:
    raise ValueError("GROQ_API_KEY missing!")

# --------------------------------------------------------
# USER FUNCTIONS
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
# CHAT STORAGE (LIMITED)
# --------------------------------------------------------
def save_message(user_id, question, answer):
    doc = {
        "user_id": user_id,
        "question": question,
        "answer": answer,
        "created_at": int(time.time() * 1000)
    }

    try:
        chat_collection.insert_one(doc)

        # Keep only last 50 messages
        messages = list(chat_collection.find(
            {"user_id": user_id},
            sort={"created_at": -1}
        ))

        if len(messages) > 50:
            for msg in messages[50:]:
                chat_collection.delete_one({"_id": msg["_id"]})

    except Exception as e:
        logger.error(f"Save error: {e}")

# --------------------------------------------------------
# CACHE (VERY IMPORTANT)
# --------------------------------------------------------
def check_cache(question):
    try:
        doc = chat_collection.find_one({"question": question})
        if doc:
            return doc.get("answer")
    except Exception:
        return None

# --------------------------------------------------------
# GROQ API CALL
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
        logger.error(f"Groq API error: {e}")
        return "Service temporarily unavailable."



# --------------------------------------------------------
# MAIN CHAT FUNCTION (CORE LOGIC)
# --------------------------------------------------------
def get_ai_response(user_id, prompt):
    user = get_user(user_id)

    # Reset daily count
    today = str(datetime.date.today())
    if user.get("last_reset") != today:
        user["daily_count"] = 0
        user["last_reset"] = today

    #  FREE LIMIT CHECK
    if not user["is_pro"] and user["daily_count"] >= 5:
        return {"status": "LIMIT_EXCEEDED"}

    #  CACHE CHECK
    cached = check_cache(prompt)
    if cached:
        logger.info("Cache hit")
        return {"status": "OK", "response": cached}

    #  CALL AI
    reply = call_groq(prompt)

    #  SAVE
    save_message(user_id, prompt, reply)

    #  UPDATE COUNT
    user["daily_count"] += 1
    update_user(user_id, user)

    return {"status": "OK", "response": reply}