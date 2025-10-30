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

def query_ai_model(prompt, user_id=None):
    """
    Main function to query AI models
    Priority: OpenRouter Free -> Hugging Face -> Fallback
    """
    # Check daily message limit
    if user_id:
        message_count = get_user_message_count_today(user_id)
        if message_count >= 20:
            return "🚫 You've reached your daily limit of 20 messages. Please upgrade to premium for unlimited chats!"

    # Try OpenRouter first (most reliable free option)
    response = try_openrouter(prompt)
    if response and response != "ERROR":
        return response

    # Try Hugging Face as backup
    response = try_huggingface(prompt)
    if response and response != "ERROR":
        return response

    # Final fallback - smart response
    return generate_ai_response(prompt)

def try_openrouter(prompt):
    """
    Use OpenRouter free models - much more reliable than Hugging Face
    """
    try:
        # Free models available on OpenRouter
        models = [
            "google/gemma-2b-it:free",  # Google's Gemma 2B - excellent for chat
            "mistralai/mistral-7b-instruct:free",  # Mistral 7B - very powerful
            "huggingfaceh4/zephyr-7b-beta:free"  # Zephyr 7B - chat optimized
        ]

        for model in models:
            url = "https://openrouter.ai/api/v1/chat/completions"
            headers = {
                "Content-Type": "application/json",
            }

            payload = {
                "model": model,
                "messages": [
                    {
                        "role": "system",
                        "content": "You are a helpful AI assistant that provides accurate, detailed, and friendly responses to any question. You excel at programming help, general knowledge, creative writing, and problem-solving."
                    },
                    {
                        "role": "user",
                        "content": prompt
                    }
                ],
                "max_tokens": 500,
                "temperature": 0.7
            }

            response = requests.post(url, headers=headers, json=payload, timeout=30)

            if response.status_code == 200:
                data = response.json()
                if 'choices' in data and len(data['choices']) > 0:
                    return data['choices'][0]['message']['content'].strip()
            elif response.status_code == 402:
                # Free quota exceeded, try next model
                continue

    except Exception as e:
        print(f"OpenRouter error: {e}")

    return "ERROR"

def try_huggingface(prompt):
    """
    Try Hugging Face models as backup
    """
    hf_token = Config.HUGGINGFACE_API_TOKEN

    if not hf_token:
        return "ERROR"

    # Try multiple Hugging Face models
    models = [
        "microsoft/DialoGPT-large",
        "microsoft/DialoGPT-medium",
        "facebook/blenderbot-400M-distill",
        "google/flan-t5-xxl"
    ]

    for model in models:
        try:
            url = f"https://api-inference.huggingface.co/models/{model}"
            headers = {"Authorization": f"Bearer {hf_token}"}

            payload = {
                "inputs": prompt,
                "parameters": {
                    "max_new_tokens": 300,
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "do_sample": True,
                    "return_full_text": False
                },
                "options": {
                    "wait_for_model": True
                }
            }

            response = requests.post(url, headers=headers, json=payload, timeout=45)

            if response.status_code == 200:
                data = response.json()
                # Parse different response formats
                if isinstance(data, list) and len(data) > 0:
                    if "generated_text" in data[0]:
                        text = data[0]["generated_text"]
                        # Remove the original prompt if it's included
                        if prompt in text:
                            text = text.replace(prompt, "").strip()
                        return text
                    return str(data[0])
                elif isinstance(data, dict) and "generated_text" in data:
                    return data["generated_text"]

            elif response.status_code == 503:
                # Model loading, wait and continue to next
                time.sleep(5)
                continue

        except Exception as e:
            print(f"Hugging Face model {model} error: {e}")
            continue

    return "ERROR"

def generate_ai_response(prompt):
    """
    Smart fallback responses when APIs fail
    """
    prompt_lower = prompt.lower()

    # Programming questions
    if any(word in prompt_lower for word in ['programming', 'code', 'function', 'variable', 'array', 'list', 'string', 'int', 'float', 'java', 'python', 'c++', 'javascript', 'react', 'flutter', 'dart']):
        if 'array' in prompt_lower and 'c' in prompt_lower:
            return """In C programming, an array is a collection of items stored at contiguous memory locations that allows storing multiple items of the same type together.

**Key Points:**
- Arrays have fixed size
- Zero-indexed (first element at index 0)
- All elements are of the same type

**Example:**
```c
#include <stdio.h>

int main() {
    int numbers[5] = {1, 2, 3, 4, 5};  // Declaration & initialization
    
    // Accessing elements
    printf("First element: %d\\n", numbers[0]);  // Output: 1
    printf("Third element: %d\\n", numbers[2]);  // Output: 3
    
    return 0;
}"""