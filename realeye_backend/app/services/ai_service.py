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
    IMPROVED: Better Hugging Face API implementation with multiple model fallbacks
    """
    # Check daily message limit
    if user_id:
        message_count = get_user_message_count_today(user_id)
        if message_count >= 20:
            return "🚫 You've reached your daily limit of 20 messages. Please upgrade to premium for unlimited chats!"

    hf_token = Config.HUGGINGFACE_API_TOKEN

    # If no token, use smart responses
    if not hf_token:
        print("❌ No Hugging Face token found, using fallback")
        return generate_smart_response(prompt)

    # Try multiple models in sequence
    models_to_try = [
        "microsoft/DialoGPT-large",  # Better for conversation
        "microsoft/DialoGPT-medium",
        "google/flan-t5-large",
        "facebook/blenderbot-400M-distill"
    ]

    for model in models_to_try:
        try:
            print(f"🤖 Trying model: {model}")
            response = try_huggingface_model(prompt, model, hf_token)
            if response and response != generate_smart_response(prompt):
                return response
        except Exception as e:
            print(f"❌ Model {model} failed: {e}")
            continue

    print("❌ All models failed, using fallback")
    return generate_smart_response(prompt)

def try_huggingface_model(prompt, model, hf_token):
    """Try a specific Hugging Face model"""
    url = f"https://api-inference.huggingface.co/models/{model}"
    headers = {"Authorization": f"Bearer {hf_token}"}

    # Different payloads for different model types
    if "dialo" in model.lower() or "blender" in model.lower():
        # Conversational models
        payload = {
            "inputs": {
                "text": prompt,
                "past_user_inputs": [],
                "past_responses": []
            },
            "parameters": {
                "max_length": 200,
                "temperature": 0.7,
                "top_p": 0.9,
                "do_sample": True
            },
            "options": {
                "wait_for_model": True,
                "use_cache": True
            }
        }
    else:
        # Text generation models
        formatted_prompt = f"Please provide a helpful and friendly response to this question: {prompt}"
        payload = {
            "inputs": formatted_prompt,
            "parameters": {
                "max_new_tokens": 150,
                "temperature": 0.7,
                "top_p": 0.9,
                "do_sample": True,
                "return_full_text": False
            },
            "options": {
                "wait_for_model": True
            }
        }

    try:
        print(f"📡 Sending request to: {model}")
        response = requests.post(url, headers=headers, json=payload, timeout=45)
        print(f"📊 Response status: {response.status_code}")

        if response.status_code == 200:
            data = response.json()
            print(f"📦 Raw response: {data}")

            # Parse response based on model type
            if "dialo" in model.lower() or "blender" in model.lower():
                # Conversational model response
                if isinstance(data, dict) and "generated_text" in data:
                    return data["generated_text"]
            else:
                # Text generation model response
                if isinstance(data, list) and len(data) > 0:
                    if "generated_text" in data[0]:
                        return data[0]["generated_text"]
                    elif "generated_text" in data:
                        return data["generated_text"]

            # Fallback extraction
            if isinstance(data, list) and len(data) > 0:
                if isinstance(data[0], dict):
                    for key in ["generated_text", "text", "response"]:
                        if key in data[0]:
                            return data[0][key]
                    # Return first string value found
                    for value in data[0].values():
                        if isinstance(value, str) and len(value) > 10:
                            return value

        elif response.status_code == 503:
            print(f"⏳ Model {model} is loading, trying next model...")
            return None
        else:
            print(f"❌ API Error {response.status_code}: {response.text}")
            return None

    except requests.exceptions.Timeout:
        print(f"⏰ Timeout for model {model}")
        return None
    except Exception as e:
        print(f"💥 Exception with model {model}: {e}")
        return None

    return None

def generate_smart_response(prompt):
    """
    Enhanced smart responses with more programming topics
    """
    prompt_lower = prompt.lower().strip()

    # Greetings
    if any(word in prompt_lower for word in ['hello', 'hi', 'hey', 'hola', 'namaste']):
        return "Hello! 👋 I'm your AI study assistant! I'm here to help you with programming, math, science, or any other subject. What would you like to learn today?"

    # Programming questions - EXPANDED
    elif 'ascii' in prompt_lower:
        return ("**ASCII (American Standard Code for Information Interchange)** is a character encoding standard that represents text in computers. "
                "It uses 7-bit codes to represent 128 characters including:\n"
                "• Letters (A-Z, a-z)\n• Numbers (0-9)\n• Punctuation marks\n• Control characters\n\n"
                "For example: 'A' = 65, 'a' = 97, '0' = 48")

    elif 'variable' in prompt_lower:
        return ("**Variables** in programming are containers that store data values.\n\n"
                "📝 **Key characteristics:**\n"
                "• Have a name (identifier)\n• Hold a value\n• Have a data type\n• Can be modified\n\n"
                "**Example in different languages:**\n"
                "Python: `x = 5`\nJava: `int x = 5;`\nJavaScript: `let x = 5;`")

    elif 'datatype' in prompt_lower or 'data type' in prompt_lower:
        return ("**Data types** define the type of data a variable can hold.\n\n"
                "🔧 **Common data types:**\n"
                "• **Primitive**: int, float, char, boolean\n"
                "• **Composite**: array, string, object, list\n"
                "• **Special**: null, undefined\n\n"
                "Each programming language has its own specific data types with different sizes and capabilities.")

    elif 'array' in prompt_lower and 'c' in prompt_lower:
        return ("**Arrays in C Programming:**\n"
                "An array in C is a collection of items stored at contiguous memory locations.\n\n"
                "📝 **Syntax:**\n"
                "```c\nint arr[5]; // declares integer array of size 5\nint arr[5] = {1, 2, 3, 4, 5}; // initialization\n```\n"
                "**Key features:** Fixed size, same data type, index access starting from 0.")

    elif any(word in prompt_lower for word in ['programming', 'code', 'function', 'loop', 'string', 'int', 'float', 'boolean']):
        return "I'd be happy to help with programming concepts! Could you specify which programming language and what particular aspect you're interested in?"

    # Study related
    elif any(word in prompt_lower for word in ['study', 'learn', 'teach', 'explain']):
        return "I can help you study various subjects! Please tell me what topic you're working on - programming, math, science, history, or anything else."

    # Default fallback - MORE HELPFUL
    return ("I'm your AI study assistant! I can help you with:\n"
            "• Programming concepts (variables, functions, data types)\n"
            "• Math problems and explanations\n"
            "• Science topics\n"
            "• Study techniques\n"
            "• Code examples\n\n"
            "What specific topic would you like help with today?")