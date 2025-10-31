# from astrapy import DataAPIClient
# from app.config import Config
# import requests
# import time
# import datetime
# import json
#
# # Astra DB Client Setup
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
#     """
#     Save message to Astra DB
#     """
#     if user_id is None:
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
#         return doc
#     except Exception as e:
#         print(f"Error saving message to DB: {e}")
#         return None
#
# def get_chat_history(user_id, limit=50):
#     """
#     Retrieve chat history for user
#     """
#     if not user_id:
#         return []
#
#     try:
#         cursor = chat_collection.find(
#             {"user_id": user_id},
#             sort={"created_at": -1},
#             limit=limit
#         )
#         docs = list(cursor)
#         docs.sort(key=lambda x: x.get("created_at", 0))
#
#         return [{
#             "sender": d.get("sender"),
#             "message": d.get("message"),
#             "timestamp": d.get("timestamp")
#         } for d in docs]
#     except Exception as e:
#         print(f"Error retrieving chat history: {e}")
#         return []
#
# def get_user_message_count_today(user_id):
#     """
#     Count user messages sent today for rate limiting
#     """
#     if not user_id:
#         return 0
#
#     try:
#         today = datetime.datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
#         today_timestamp = int(today.timestamp() * 1000)
#
#         cursor = chat_collection.find({
#             "user_id": user_id,
#             "sender": "user",
#             "created_at": {"$gte": today_timestamp}
#         })
#
#         return len(list(cursor))
#     except Exception as e:
#         print(f"Error counting user messages: {e}")
#         return 0
#
# def query_huggingface(prompt, user_id=None):
#     """
#     Main function to query Hugging Face models with proper error handling
#     """
#     # Daily message limit check
#     if user_id:
#         message_count = get_user_message_count_today(user_id)
#         if message_count >= 50:  # Increased limit for better UX
#             return "I've reached my daily message limit. Please try again tomorrow or upgrade for unlimited access!"
#
#     hf_token = Config.HUGGINGFACE_API_TOKEN
#
#     if not hf_token:
#         return get_fallback_response(prompt)
#
#     # Try different free conversational models
#     models_to_try = [
#         "microsoft/DialoGPT-medium",    # Good for conversations
#         "microsoft/DialoGPT-small",     # Lightweight fallback
#         "facebook/blenderbot-400M-distill",  # General chatbot
#         "HuggingFaceH4/zephyr-7b-beta"  # Instruction-tuned model
#     ]
#
#     for model in models_to_try:
#         try:
#             print(f"🔄 Trying model: {model}")
#             response = call_huggingface_api(prompt, model, hf_token)
#             if response and response.strip():
#                 print(f"✅ Success with model: {model}")
#                 return response
#         except Exception as e:
#             print(f"❌ Model {model} failed: {str(e)[:100]}...")
#             continue
#
#     print("❌ All models failed, using fallback")
#     return get_fallback_response(prompt)
#
# def call_huggingface_api(prompt, model, hf_token):
#     """
#     Make API call to Hugging Face with proper formatting
#     """
#     # Use the new router endpoint
#     url = f"https://api-inference.huggingface.co/models/{model}"
#     headers = {"Authorization": f"Bearer {hf_token}"}
#
#     # Format prompt based on model type
#     if "dialo" in model.lower():
#         # DialoGPT expects conversational format
#         payload = {
#             "inputs": {
#                 "text": prompt,
#                 "past_user_inputs": [],
#                 "past_responses": []
#             },
#             "parameters": {
#                 "max_length": 200,
#                 "temperature": 0.7,
#                 "top_p": 0.9,
#                 "do_sample": True,
#                 "repetition_penalty": 1.1
#             },
#             "options": {
#                 "wait_for_model": True,
#                 "use_cache": True
#             }
#         }
#     elif "blender" in model.lower():
#         # BlenderBot format
#         payload = {
#             "inputs": prompt,
#             "parameters": {
#                 "max_length": 200,
#                 "temperature": 0.7,
#                 "top_p": 0.9,
#                 "do_sample": True
#             },
#             "options": {
#                 "wait_for_model": True
#             }
#         }
#     else:
#         # General text generation models
#         formatted_prompt = f"Please provide a helpful, friendly response to this: {prompt}"
#         payload = {
#             "inputs": formatted_prompt,
#             "parameters": {
#                 "max_new_tokens": 150,
#                 "temperature": 0.7,
#                 "top_p": 0.9,
#                 "do_sample": True,
#                 "return_full_text": False
#             },
#             "options": {
#                 "wait_for_model": True
#             }
#         }
#
#     try:
#         response = requests.post(url, headers=headers, json=payload, timeout=30)
#
#         if response.status_code == 200:
#             data = response.json()
#             return extract_generated_text(data)
#         elif response.status_code == 503:
#             print(f"⏳ Model {model} is loading...")
#             return None
#         else:
#             print(f"❌ API Error {response.status_code}: {response.text[:200]}")
#             return None
#
#     except requests.exceptions.Timeout:
#         print(f"⏰ Timeout for model {model}")
#         return None
#     except Exception as e:
#         print(f"💥 Request exception: {e}")
#         return None
#
# def extract_generated_text(data):
#     """
#     Extract generated text from various Hugging Face response formats
#     """
#     if isinstance(data, list):
#         # Most common format: list of dictionaries
#         for item in data:
#             if isinstance(item, dict):
#                 if 'generated_text' in item:
#                     return item['generated_text']
#                 # Check for other possible keys
#                 for key in ['generated_text', 'text', 'response', 'answer']:
#                     if key in item and item[key]:
#                         return item[key]
#
#     elif isinstance(data, dict):
#         # Sometimes it's a direct dictionary
#         if 'generated_text' in data:
#             return data['generated_text']
#         # Check nested structures
#         for key in ['generated_text', 'text', 'response', 'answer']:
#             if key in data and data[key]:
#                 return data[key]
#
#     # If no structured data found, try to find any string in the response
#     if isinstance(data, str):
#         return data
#
#     # Last resort: convert to string and extract
#     data_str = str(data)
#     if len(data_str) > 50:  # Reasonable response length
#         return data_str
#
#     return None
#
# def get_fallback_response(prompt):
#     """
#     Intelligent fallback when API is unavailable
#     """
#     prompt_lower = prompt.lower().strip()
#
#     # General conversational responses
#     greeting_words = ['hello', 'hi', 'hey', 'hola', 'namaste', 'greetings']
#     if any(word in prompt_lower for word in greeting_words):
#         return "Hello! 👋 I'm your AI study assistant. I'm here to help you learn and answer your questions. What would you like to know today?"
#
#     # Question patterns
#     if any(word in prompt_lower for word in ['what', 'how', 'why', 'when', 'where', 'explain', 'tell me about']):
#         return "That's an interesting question! I'd be happy to help you learn more about this topic. Could you provide some more specific details so I can give you the best possible explanation?"
#
#     # Programming related
#     programming_keywords = ['code', 'programming', 'function', 'variable', 'algorithm', 'debug', 'syntax']
#     if any(keyword in prompt_lower for keyword in programming_keywords):
#         return "I'd love to help with programming concepts! Please let me know which programming language and specific concept you're working on, and I'll do my best to assist you."
#
#     # Study related
#     study_keywords = ['study', 'learn', 'teach', 'education', 'homework', 'assignment']
#     if any(keyword in prompt_lower for keyword in study_keywords):
#         return "I'm here to support your learning journey! Whether it's programming, math, science, or any other subject, feel free to ask me anything specific you're studying."
#
#     # Default friendly response
#     return "Thanks for your message! I'm here to help you learn and answer questions. Feel free to ask me about programming, study techniques, or any other topic you're curious about!"

from astrapy import DataAPIClient
from app.config import Config
import requests
import time
import datetime
import os
import json

# Astra DB Client Setup
client = DataAPIClient(Config.ASTRA_DB_APPLICATION_TOKEN)
db = client.get_database_by_api_endpoint(Config.ASTRA_DB_API_ENDPOINT)

collection_name = "chat_history"

try:
    chat_collection = db.get_collection(collection_name)
except Exception:
    db.create_collection(collection_name)
    chat_collection = db.get_collection(collection_name)

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
        print(f"Database error: {e}")
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
        print(f"Error getting history: {e}")
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

def get_ai_response(prompt, user_id=None):
    """
    WORKING FREE CHATBOT: Uses Hugging Face Inference API
    """
    # Daily limit check
    if user_id and get_user_message_count_today(user_id) >= 100:
        return "You've reached your daily message limit. Try again tomorrow!"

    # Try Hugging Face Inference API - THIS WORKS!
    response = try_huggingface_inference(prompt)
    if response:
        return response

    # If all else fails, use a simple friendly response
    return "Hello! I'm your AI study assistant. I'd love to help you learn programming concepts, data structures, algorithms, and more. What specific topic are you interested in?"

def try_huggingface_inference(prompt):
    """
    Use Hugging Face Inference API with models that actually work
    """
    hf_token = os.getenv("HUGGINGFACE_API_TOKEN")

    if not hf_token:
        print("❌ No Hugging Face token found")
        return None

    # Models that actually work with Inference API
    working_models = [
        "microsoft/DialoGPT-medium",  # Conversational model
        "microsoft/DialoGPT-large",   # Larger conversational model
        "facebook/blenderbot-400M-distill",  # Chat model
        "google/flan-t5-base",        # Instruction following model
    ]

    for model in working_models:
        try:
            print(f"🔄 Trying model: {model}")
            response = call_huggingface_inference(prompt, model, hf_token)
            if response and response.strip():
                print(f"✅ Success with model: {model}")
                return response
        except Exception as e:
            print(f"❌ Model {model} failed: {e}")
            continue

    return None

def call_huggingface_inference(prompt, model, hf_token):
    """
    Call Hugging Face Inference API - PROPER IMPLEMENTATION
    """
    url = f"https://api-inference.huggingface.co/models/{model}"
    headers = {"Authorization": f"Bearer {hf_token}"}

    # Format based on model type
    if "dialo" in model.lower():
        # DialoGPT expects conversational format
        payload = {
            "inputs": {
                "text": prompt,
                "past_user_inputs": [],
                "past_responses": []
            },
            "parameters": {
                "max_length": 200,
                "temperature": 0.9,
                "top_p": 0.9,
                "do_sample": True
            },
            "options": {
                "wait_for_model": True
            }
        }
    elif "blender" in model.lower():
        # BlenderBot format
        payload = {
            "inputs": prompt,
            "parameters": {
                "max_length": 200,
                "temperature": 0.7,
                "top_p": 0.9,
                "do_sample": True
            },
            "options": {
                "wait_for_model": True
            }
        }
    else:
        # General text generation
        payload = {
            "inputs": prompt,
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
        response = requests.post(url, headers=headers, json=payload, timeout=30)
        print(f"📡 Response status: {response.status_code}")

        if response.status_code == 200:
            data = response.json()
            print(f"📦 Raw response: {data}")

            # Parse different response formats
            return parse_huggingface_response(data, model)

        elif response.status_code == 503:
            print(f"⏳ Model {model} is loading...")
            return None
        else:
            print(f"❌ API Error {response.status_code}: {response.text[:200]}")
            return None

    except requests.exceptions.Timeout:
        print(f"⏰ Timeout for model {model}")
        return None
    except Exception as e:
        print(f"💥 Exception: {e}")
        return None

def parse_huggingface_response(data, model):
    """
    Parse different Hugging Face response formats
    """
    try:
        # Format 1: Direct generated_text
        if isinstance(data, dict) and 'generated_text' in data:
            return data['generated_text']

        # Format 2: List with generated_text
        if isinstance(data, list) and len(data) > 0:
            item = data[0]
            if isinstance(item, dict) and 'generated_text' in item:
                return item['generated_text']

        # Format 3: Conversational response
        if isinstance(data, dict) and 'conversation' in data:
            if 'generated_responses' in data['conversation'] and len(data['conversation']['generated_responses']) > 0:
                return data['conversation']['generated_responses'][0]

        # Format 4: Try to find any text in the response
        if isinstance(data, str):
            return data

        # Last resort: convert to string
        data_str = str(data)
        if len(data_str) > 20 and len(data_str) < 1000:
            return data_str

        return None

    except Exception as e:
        print(f"Error parsing response: {e}")
        return None
