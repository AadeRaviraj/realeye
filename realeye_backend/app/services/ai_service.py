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

from astrapy import DataAPIClient
from app.config import Config
import requests, time, datetime, json

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
    FIXED: Proper Hugging Face API implementation
    """
    # Check daily message limit
    if user_id:
        message_count = get_user_message_count_today(user_id)
        if message_count >= 20:
            return "🚫 You've reached your daily limit of 20 messages. Please upgrade to premium for unlimited chats!"

    hf_token = Config.HUGGINGFACE_API_TOKEN

    # If no token, use smart responses
    if not hf_token:
        return generate_smart_response(prompt)

    # Use Google Flan-T5 model - it's reliable and always available
    model = "google/flan-t5-large"
    url = f"https://api-inference.huggingface.co/models/{model}"
    headers = {"Authorization": f"Bearer {hf_token}"}

    # Format prompt for better responses
    formatted_prompt = f"Please provide a helpful and friendly response to: {prompt}"

    payload = {
        "inputs": formatted_prompt,
        "parameters": {
            "max_new_tokens": 150,
            "temperature": 0.7,
            "top_p": 0.9,
            "do_sample": True
        },
        "options": {
            "wait_for_model": True
        }
    }

    try:
        print(f"🤖 Sending request to Hugging Face: {prompt}")
        response = requests.post(url, headers=headers, json=payload, timeout=30)
        print(f"📡 Response status: {response.status_code}")

        if response.status_code == 200:
            data = response.json()
            print(f"📦 Response data: {data}")

            # Extract generated text
            if isinstance(data, list) and len(data) > 0:
                generated_text = data[0].get('generated_text', '')
                if generated_text:
                    return generated_text

            # If no generated text, return smart response
            return generate_smart_response(prompt)

        elif response.status_code == 503:
            # Model is loading, use smart response
            print("⏳ Model is loading, using smart response")
            return generate_smart_response(prompt)
        else:
            print(f"❌ API Error: {response.status_code} - {response.text}")
            return generate_smart_response(prompt)

    except Exception as e:
        print(f"💥 Exception: {e}")
        return generate_smart_response(prompt)
def generate_smart_response(prompt):
    """
    Generate intelligent, friendly responses when API fails
    """
    prompt_lower = prompt.lower().strip()

    # Greetings
    if any(word in prompt_lower for word in ['hello', 'hi', 'hey', 'hola', 'namaste']):
        return ("Hello! 👋 I'm your AI study assistant! I'm here to help you with any questions "
                "about programming, math, science, or any other subject. What would you like to learn today?")

    # Programming questions
    elif any(word in prompt_lower for word in [
        'programming', 'code', 'function', 'variable', 'array', 'list', 'string', 'int', 'float']):
        if 'array' in prompt_lower and 'c' in prompt_lower:
            return (
                "**Arrays in C Programming:**\n"
                "An array in C is a collection of items stored at contiguous memory locations. "
                "It allows you to store multiple items of the same type together.\n"
                "📝 **Basic Syntax:**\n"
                "```c\nint arr[5]; // declares an integer array of size 5\n```\n"
            )
        return "It seems you're asking about programming. Could you specify your question in more detail?"

    # Default fallback
    return "I'm here to help! Can you please clarify your question?"
