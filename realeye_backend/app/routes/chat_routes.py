# from flask import Blueprint, request, jsonify
# from app.services.ai_service import query_huggingface, save_message, get_chat_history

# chat_bp = Blueprint('chat_bp', __name__)

# @chat_bp.route('/chat', methods=['POST'])
# def chat():
#     data = request.get_json()
#     user_id = data.get('user_id')
#     message = data.get('message')

#     if not user_id or not message:
#         return jsonify({"error": "Missing user_id or message"}), 400

#     save_message(user_id, "user", message)
#     reply = query_huggingface(message)
#     save_message(user_id, "ai", reply)

#     return jsonify({"reply": reply})


# @chat_bp.route('/chat/history', methods=['GET'])
# def history():
#     user_id = request.args.get('user_id')
#     if not user_id:
#         return jsonify({"error": "Missing user_id"}), 400

#     messages = get_chat_history(user_id)
#     return jsonify({"messages": messages})

# app/routes/chat_routes.py


from flask import Blueprint, jsonify, request
from app.services.ai_service import save_message, get_chat_history, query_huggingface

chat_bp = Blueprint('chat_bp', __name__)

# POST /api/chat/send
@chat_bp.route('/send', methods=['POST'])
def send_message():
    data = request.get_json() or {}
    user_id = data.get('user_id') or data.get('user')  # support both keys
    message = data.get('message')

    if not message:
        return jsonify({"error": "message is required"}), 400

    # Save user message
    save_message(user_id, message, sender="user")

    # Generate AI reply
    ai_response = query_huggingface(message)

    # Save AI reply
    save_message(user_id, ai_response, sender="ai")

    return jsonify({"reply": ai_response})

# GET /api/chat/history?user_id=...
@chat_bp.route('/history', methods=['GET'])
def history():
    user_id = request.args.get('user_id') or request.args.get('user')
    if not user_id:
        return jsonify({"error": "user_id required"}), 400
    messages = get_chat_history(user_id)
    return jsonify({"messages": messages})
