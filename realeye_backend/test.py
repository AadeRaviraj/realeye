import requests

API_KEY = "xxxxxxx"

url = "https://api.groq.com/openai/v1/chat/completions"

headers = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}

data = {
    "model": "llama-3.1-8b-instant",
    "messages": [
        {"role": "user", "content": "Explain OOP in simple terms"}
    ]
}

response = requests.post(url, headers=headers, json=data)

print(response.json())