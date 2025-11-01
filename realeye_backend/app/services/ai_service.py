# from astrapy import DataAPIClient
# from app.config import Config
# import requests
# import time
# import datetime
#
# # ------------------ ASTRA DB ------------------
# client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
# db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)
# collection_name = "chat_history"
#
# try:
#     chat_collection = db.get_collection(collection_name)
# except Exception:
#     db.create_collection(collection_name)
#     chat_collection = db.get_collection(collection_name)
#
# # ------------------ CHAT HISTORY ------------------
# def save_message(user_id, message, sender):
#     if not user_id:
#         user_id = "anonymous"
#
#     doc = {
#         "user_id": user_id,
#         "message": message,
#         "sender": sender,
#         "created_at": int(time.time() * 1000),
#         "timestamp": datetime.datetime.now().isoformat()
#     }
#
#     try:
#         chat_collection.insert_one(doc)
#         return True
#     except Exception as e:
#         print(f"Database error: {e}")
#         return False
#
# def get_chat_history(user_id, limit=50):
#     if not user_id:
#         return []
#
#     try:
#         cursor = chat_collection.find(
#             {"user_id": user_id},
#             sort={"created_at": -1},
#             limit=limit
#         )
#         docs = sorted(list(cursor), key=lambda x: x.get("created_at", 0))
#         return [{"sender": d.get("sender"), "message": d.get("message"), "timestamp": d.get("timestamp")} for d in docs]
#     except Exception as e:
#         print(f"Error getting history: {e}")
#         return []
#
# def get_user_message_count_today(user_id):
#     if not user_id:
#         return 0
#
#     try:
#         today_ts = int(datetime.datetime.now().replace(hour=0, minute=0, second=0, microsecond=0).timestamp() * 1000)
#         cursor = chat_collection.find({"user_id": user_id, "sender": "user", "created_at": {"$gte": today_ts}})
#         return len(list(cursor))
#     except Exception as e:
#         print(f"Error counting messages: {e}")
#         return 0
#
# # ------------------ AI RESPONSE ------------------
# def get_ai_response(prompt, user_id=None):
#     if user_id and get_user_message_count_today(user_id) >= Config.MAX_DAILY_MESSAGES:
#         return "You've reached your daily message limit. Try again tomorrow!"
#
#     gemini_resp = call_gemini_api(prompt)
#     if gemini_resp:
#         return gemini_resp.strip()
#
#     deepseek_resp = call_deepseek_api(prompt)
#     if deepseek_resp:
#         return deepseek_resp.strip()
#
#     return "I'm your AI programming tutor. Ask me about Python, Java, Flutter, or algorithms."
#
# # ------------------ GEMINI ------------------
# def call_gemini_api(prompt):
#     api_key = Config.GEMINI_API_KEY
#     if not api_key:
#         print("❌ Gemini API key missing")
#         return None
#
#     url = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent"
#     headers = {"Content-Type": "application/json", "Authorization": f"Bearer {api_key}"}
#     payload = {
#         "contents": [{"role": "user", "parts": [{"text": f"You are StudyBot, a friendly AI programming tutor.\n\nQuestion: {prompt}"}]}],
#         "generationConfig": {"temperature": 0.7, "topK": 40, "topP": 0.95, "maxOutputTokens": 1024}
#     }
#
#     try:
#         resp = requests.post(url, headers=headers, json=payload, timeout=30)
#         if resp.status_code == 200:
#             data = resp.json()
#             candidates = data.get("candidates", [])
#             if candidates:
#                 parts = candidates[0].get("content", {}).get("parts", [])
#                 if parts and "text" in parts[0]:
#                     return parts[0]["text"]
#             if "output_text" in data:
#                 return data["output_text"]
#     except Exception as e:
#         print(f"Gemini API error: {e}")
#     return None
#
# # ------------------ DEEPSEEK ------------------
# def call_deepseek_api(prompt):
#     try:
#         url = "https://api.deepseek.com/chat/completions"
#         headers = {"Content-Type": "application/json"}
#         payload = {
#             "model": "deepseek-chat",
#             "messages": [{"role": "system", "content": "You are a helpful programming tutor."},
#                          {"role": "user", "content": prompt}],
#             "stream": False
#         }
#         resp = requests.post(url, json=payload, headers=headers, timeout=30)
#         if resp.status_code == 200:
#             data = resp.json()
#             return data.get("choices", [{}])[0].get("message", {}).get("content", "")
#     except Exception as e:
#         print(f"DeepSeek API error: {e}")
#     return None


from astrapy import DataAPIClient
from app.config import Config
import google.generativeai as genai
import requests
import time
import datetime
import os
import json
import logging

# --------------------------------------------------------
# ✅ Logging setup
# --------------------------------------------------------
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("AIService")

# --------------------------------------------------------
# ✅ Astra DB Client Setup
# --------------------------------------------------------
client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)
collection_name = "chat_history"

try:
    chat_collection = db.get_collection(collection_name)
except Exception:
    db.create_collection(collection_name)
    chat_collection = db.get_collection(collection_name)

# --------------------------------------------------------
# ✅ Google Gemini Setup
# --------------------------------------------------------
GEMINI_API_KEY = Config.GEMINI_API_KEY
if not GEMINI_API_KEY:
    raise ValueError("❌ GEMINI_API_KEY missing in environment variables!")

try:
    genai.configure(api_key=GEMINI_API_KEY)
    model = genai.GenerativeModel("gemini-2.0-flash-001")
    logger.info("✅ Gemini configured successfully with gemini-2.0-flash-001")
except Exception as e:
    logger.error(f"Gemini configuration failed: {str(e)}")
    model = None

# --------------------------------------------------------
# ✅ Database Functions
# --------------------------------------------------------
def save_message(user_id, message, sender):
    if not user_id:
        user_id = "anonymous"

    doc = {
        "user_id": user_id,
        "message": message,
        "sender": sender,
        "created_at": int(time.time() * 1000),
        "timestamp": datetime.datetime.now().isoformat()
    }

    try:
        chat_collection.insert_one(doc)
        return True
    except Exception as e:
        logger.error(f"Database error: {e}")
        return False


def get_chat_history(user_id, limit=50):
    if not user_id:
        return []

    try:
        cursor = chat_collection.find(
            {"user_id": user_id},
            sort={"created_at": -1},
            limit=limit
        )
        docs = list(cursor)
        docs.sort(key=lambda x: x.get("created_at", 0))

        return [{
            "sender": d.get("sender"),
            "message": d.get("message"),
            "timestamp": d.get("timestamp")
        } for d in docs]
    except Exception as e:
        logger.error(f"Error getting history: {e}")
        return []


def get_user_message_count_today(user_id):
    if not user_id:
        return 0

    try:
        today = datetime.datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
        today_timestamp = int(today.timestamp() * 1000)

        cursor = chat_collection.find({
            "user_id": user_id,
            "sender": "user",
            "created_at": {"$gte": today_timestamp}
        })

        return len(list(cursor))
    except Exception:
        return 0

# --------------------------------------------------------
# ✅ AI Logic
# --------------------------------------------------------
def get_ai_response(prompt, user_id=None):
    """Main AI response handler"""
    # Rate limit check
    if user_id and get_user_message_count_today(user_id) >= 100:
        return "⚠️ You've reached your daily message limit. Try again tomorrow!"

    # Try Gemini first
    try:
        if model:
            response = model.generate_content(prompt)
            ai_reply = response.text.strip()
            logger.info(f"🧠 Gemini success: {ai_reply[:100]}...")
            return ai_reply
    except Exception as e:
        logger.error(f"Gemini SDK error: {str(e)}")

    # Try Gemini REST API fallback
    try:
        api_reply = call_gemini_rest_api(prompt)
        if api_reply:
            return api_reply
    except Exception as e:
        logger.error(f"Gemini REST fallback failed: {e}")

    # DeepSeek as secondary fallback
    try:
        ds_reply = call_deepseek_api(prompt)
        if ds_reply:
            return ds_reply
    except Exception as e:
        logger.error(f"DeepSeek fallback failed: {e}")

    # Final fallback
    return "I'm your AI tutor! Ask me about programming, Flutter, Python, or any computer science topic."

# --------------------------------------------------------
# ✅ REST API Fallback for Gemini
# --------------------------------------------------------
def call_gemini_rest_api(prompt):
    api_key = GEMINI_API_KEY
    if not api_key:
        return None

    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key={api_key}"
    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {"temperature": 0.7, "maxOutputTokens": 1024}
    }

    try:
        response = requests.post(url, json=payload, timeout=30)
        logger.info(f"📡 Gemini REST status: {response.status_code}")

        if response.status_code == 200:
            data = response.json()
            if "candidates" in data and len(data["candidates"]) > 0:
                parts = data["candidates"][0]["content"]["parts"]
                return parts[0].get("text", "").strip()
        logger.error(f"Gemini REST error: {response.text}")
    except Exception as e:
        logger.error(f"Gemini REST exception: {e}")
    return None

# --------------------------------------------------------
# ✅ DeepSeek API fallback
# --------------------------------------------------------
def call_deepseek_api(prompt):
    try:
        url = "https://api.deepseek.com/chat/completions"
        headers = {"Content-Type": "application/json"}
        payload = {
            "model": "deepseek-chat",
            "messages": [
                {"role": "system", "content": "You are a friendly programming tutor."},
                {"role": "user", "content": prompt}
            ],
            "stream": False
        }
        response = requests.post(url, json=payload, headers=headers, timeout=20)
        if response.status_code == 200:
            data = response.json()
            return data["choices"][0]["message"]["content"]
    except Exception as e:
        logger.error(f"DeepSeek API error: {e}")
    return None
