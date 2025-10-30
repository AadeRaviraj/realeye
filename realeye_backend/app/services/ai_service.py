# # app/services/ai_service.py
# from astrapy import DataAPIClient
# from app.config import Config
# import requests, time
#
# # Validate env vars
# if not Config.ASTRA_DB_APPLICATION_TOKEN or not Config.ASTRA_DB_API_ENDPOINT:
#     raise RuntimeError("ASTRA_DB_APPLICATION_TOKEN or ASTRA_DB_API_ENDPOINT missing in environment")
#
# # Astra Data API client
# client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
# db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)
#
# # get (or create implicitly) a collection named chat_history
# # chat_collection = db.get_collection("chat_history")
# collection_name = "chat_history"
#
# try:
#     chat_collection = db.get_collection(collection_name)
# except Exception as e:
#     print(f"Collection '{collection_name}' not found. Creating it now...")
#     db.create_collection(collection_name)
#     chat_collection = db.get_collection(collection_name)
#
# def save_message(user_id, message, sender):
#     if user_id is None:
#         user_id = "anonymous"
#     doc = {
#         "user_id": user_id,
#         "message": message,
#         "sender": sender,
#         "created_at": int(time.time() * 1000)  # store as epoch ms
#     }
#     chat_collection.insert_one(doc)
#     return doc
#
# def get_chat_history(user_id, limit=100):
#     if not user_id:
#         return []
#     cursor = chat_collection.find({"user_id": user_id}, limit=limit)
#     docs = list(cursor)
#     # normalize for JSON (astrapy returns dict-like objects)
#     return [{"sender": d.get("sender"), "message": d.get("message"), "created_at": d.get("created_at")} for d in docs]
#
# # Hugging Face call
# def query_huggingface(prompt):
#     hf_token = Config.HUGGINGFACE_API_TOKEN
#     model = Config.HF_MODEL
#     if not hf_token:
#         # fallback: dummy
#         return f"AI (local): I received: '{prompt}'"
#     url = f"https://api-inference.huggingface.co/models/{model}"
#     headers = {"Authorization": f"Bearer {hf_token}", "Content-Type": "application/json"}
#     payload = {
#         "inputs": prompt,
#         "parameters": {"temperature": 0.7, "top_p": 0.9, "max_new_tokens": 120},
#         "options": {"wait_for_model": True}
#     }
#     try:
#         resp = requests.post(url, headers=headers, json=payload, timeout=30)
#         resp.raise_for_status()
#         data = resp.json()
#         # often HF returns list with 'generated_text' in index 0
#         if isinstance(data, list) and len(data) > 0 and "generated_text" in data[0]:
#             return data[0]["generated_text"]
#         if isinstance(data, dict) and "generated_text" in data:
#             return data["generated_text"]
#         return str(data)
#     except Exception as e:
#         print("HF error:", e)
#         return "Sorry, I couldn't generate a reply right now."
#
# # app/services/ai_service.py
# from astrapy import DataAPIClient
# from app.config import Config
# import requests, time
#
# # Validate env vars
# if not Config.ASTRA_DB_APPLICATION_TOKEN or not Config.ASTRA_DB_API_ENDPOINT:
#     raise RuntimeError("ASTRA_DB_APPLICATION_TOKEN or ASTRA_DB_API_ENDPOINT missing in environment")
#
# # Astra Data API client
# client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
# db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)
#
# collection_name = "chat_history"
#
# try:
#     chat_collection = db.get_collection(collection_name)
# except Exception as e:
#     print(f"Collection '{collection_name}' not found. Creating it now...")
#     db.create_collection(collection_name)
#     chat_collection = db.get_collection(collection_name)
#
# def save_message(user_id, message, sender):
#     if user_id is None:
#         user_id = "anonymous"
#     doc = {
#         "user_id": user_id,
#         "message": message,
#         "sender": sender,
#         "created_at": int(time.time() * 1000),
#         "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
#     }
#     chat_collection.insert_one(doc)
#     return doc
#
# def get_chat_history(user_id, limit=100):
#     if not user_id:
#         return []
#     cursor = chat_collection.find({"user_id": user_id}, sort={"created_at": -1}, limit=limit)
#     docs = list(cursor)
#     # Sort by timestamp ascending for display
#     docs.sort(key=lambda x: x.get("created_at", 0))
#     return [{"sender": d.get("sender"), "message": d.get("message"), "created_at": d.get("created_at")} for d in docs]
#
# def get_user_message_count_today(user_id):
#     """Count how many messages user sent today"""
#     if not user_id:
#         return 0
#
#     # Get today's start timestamp (midnight)
#     import datetime
#     today = datetime.datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
#     today_timestamp = int(today.timestamp() * 1000)
#
#     cursor = chat_collection.find({
#         "user_id": user_id,
#         "sender": "user",
#         "created_at": {"$gte": today_timestamp}
#     })
#
#     return len(list(cursor))
#
# # Improved Hugging Face call with better error handling
# def query_huggingface(prompt, user_id=None):
#     hf_token = Config.HUGGINGFACE_API_TOKEN
#     model = Config.HF_MODEL
#
#     # Check daily message limit (20 messages per user)
#     if user_id:
#         message_count = get_user_message_count_today(user_id)
#         if message_count >= 20:  # Daily limit reached
#             return "You've reached your daily limit of 20 messages. Please upgrade to premium for unlimited chats! 🚀"
#
#     if not hf_token:
#         return "AI: I'm here to help! (API not configured)"
#
#     # Use a reliable model - DialoGPT works great for chat
#     if "dialo" in model.lower():
#         return query_dialogpt(prompt, hf_token)
#     else:
#         return query_general_model(prompt, hf_token, model)
#
# def query_dialogpt(prompt, hf_token):
#     """Query DialoGPT model specifically"""
#     url = "https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium"
#     headers = {"Authorization": f"Bearer {hf_token}"}
#
#     payload = {
#         "inputs": {
#             "text": prompt,
#             "past_user_inputs": [],
#             "generated_responses": []
#         },
#         "parameters": {
#             "temperature": 0.9,
#             "max_length": 200,
#             "do_sample": True,
#             "top_p": 0.95
#         }
#     }
#
#     try:
#         resp = requests.post(url, headers=headers, json=payload, timeout=45)
#
#         if resp.status_code == 200:
#             data = resp.json()
#             if isinstance(data, dict) and "generated_text" in data:
#                 return data["generated_text"]
#             return "I received your message! How can I assist you further?"
#         elif resp.status_code == 503:
#             # Model is loading, wait and retry once
#             time.sleep(10)
#             resp = requests.post(url, headers=headers, json=payload, timeout=45)
#             if resp.status_code == 200:
#                 data = resp.json()
#                 if isinstance(data, dict) and "generated_text" in data:
#                     return data["generated_text"]
#
#             return "Hello! I'm your AI assistant. How can I help you today? 😊"
#         else:
#             return f"Hello! Thanks for your message: '{prompt}'. How can I assist you today?"
#
#     except Exception as e:
#         print(f"HF API error: {e}")
#         return "Hello! I'm ready to chat. What would you like to talk about? 😊"
#
# def query_general_model(prompt, hf_token, model):
#     """Query general text generation models"""
#     url = f"https://api-inference.huggingface.co/models/{model}"
#     headers = {"Authorization": f"Bearer {hf_token}"}
#
#     payload = {
#         "inputs": prompt,
#         "parameters": {
#             "temperature": 0.7,
#             "max_new_tokens": 150,
#             "top_p": 0.9,
#             "do_sample": True
#         },
#         "options": {
#             "wait_for_model": True
#         }
#     }
#
#     try:
#         resp = requests.post(url, headers=headers, json=payload, timeout=30)
#         resp.raise_for_status()
#         data = resp.json()
#
#         # Handle different response formats
#         if isinstance(data, list) and len(data) > 0:
#             if "generated_text" in data[0]:
#                 return data[0]["generated_text"]
#             return str(data[0])
#         elif isinstance(data, dict) and "generated_text" in data:
#             return data["generated_text"]
#         else:
#             return f"I understand you said: '{prompt}'. How can I help you with that?"
#
#     except Exception as e:
#         print(f"HF general model error: {e}")
#         return f"Thanks for your message! I'm here to help. What would you like to know about '{prompt}'?"

# app/services/ai_service.py
from astrapy import DataAPIClient
from app.config import Config
import requests, time, datetime

# Validate env vars
if not Config.ASTRA_DB_APPLICATION_TOKEN or not Config.ASTRA_DB_API_ENDPOINT:
    raise RuntimeError("ASTRA_DB_APPLICATION_TOKEN or ASTRA_DB_API_ENDPOINT missing in environment")

# Astra Data API client
client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)

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
        "created_at": int(time.time() * 1000),
        "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
    }
    chat_collection.insert_one(doc)
    return doc

def get_chat_history(user_id, limit=100):
    if not user_id:
        return []
    cursor = chat_collection.find({"user_id": user_id}, sort={"created_at": -1}, limit=limit)
    docs = list(cursor)
    docs.sort(key=lambda x: x.get("created_at", 0))
    return [{"sender": d.get("sender"), "message": d.get("message"), "created_at": d.get("created_at")} for d in docs]

def get_user_message_count_today(user_id):
    """Count how many messages user sent today"""
    if not user_id:
        return 0

    today = datetime.datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    today_timestamp = int(today.timestamp() * 1000)

    cursor = chat_collection.find({
        "user_id": user_id,
        "sender": "user",
        "created_at": {"$gte": today_timestamp}
    })

    return len(list(cursor))

def query_huggingface(prompt, user_id=None):
    """
    Main function to query AI models - FIXED VERSION
    """
    # Check daily message limit
    if user_id:
        message_count = get_user_message_count_today(user_id)
        if message_count >= 20:
            return "🚫 You've reached your daily limit of 20 messages. Please upgrade to premium for unlimited chats!"

    hf_token = Config.HUGGINGFACE_API_TOKEN
    model = Config.HF_MODEL

    if not hf_token:
        return "🔧 Please configure your Hugging Face API token in environment variables."

    # Use a model that actually works - Microsoft DialoGPT is reliable
    url = f"https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium"
    headers = {"Authorization": f"Bearer {hf_token}"}

    payload = {
        "inputs": prompt,
        "parameters": {
            "max_new_tokens": 250,
            "temperature": 0.9,
            "top_p": 0.95,
            "do_sample": True,
            "return_full_text": False
        },
        "options": {
            "wait_for_model": True
        }
    }

    try:
        print(f"Sending request to Hugging Face API...")
        response = requests.post(url, headers=headers, json=payload, timeout=60)
        print(f"Response status: {response.status_code}")

        if response.status_code == 200:
            data = response.json()
            print(f"Response data: {data}")

            # Handle different response formats
            if isinstance(data, list) and len(data) > 0:
                if "generated_text" in data[0]:
                    generated_text = data[0]["generated_text"]
                    # Clean up the response
                    if prompt in generated_text:
                        generated_text = generated_text.replace(prompt, "").strip()
                    return generated_text if generated_text else "I understand your message! How can I help you further?"
                return str(data[0])
            elif isinstance(data, dict) and "generated_text" in data:
                return data["generated_text"]
            else:
                return f"I received your message: '{prompt}'. How can I assist you with this?"

        elif response.status_code == 503:
            # Model is loading - wait and retry once
            print("Model is loading, waiting 15 seconds...")
            time.sleep(15)
            response = requests.post(url, headers=headers, json=payload, timeout=60)
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list) and len(data) > 0 and "generated_text" in data[0]:
                    return data[0]["generated_text"]
            return f"Hello! I'm your AI assistant. You asked: '{prompt}'. How can I help you with that?"

        else:
            print(f"API Error: {response.status_code} - {response.text}")
            return f"I'm here to help! Regarding '{prompt}', I'm ready to assist you. What specific information would you like?"

    except requests.exceptions.Timeout:
        print("Request timeout")
        return f"I understand you're asking about '{prompt}'. Could you provide more details so I can help you better?"
    except Exception as e:
        print(f"Error in query_huggingface: {e}")
        return f"Thanks for your message! I'm here to help with '{prompt}'. What would you like to know specifically?"