# app/routes/chat_routes.py
from flask import Blueprint, request, jsonify
from app.services.ai_service import save_message, get_chat_history, query_huggingface

chat_bp = Blueprint("chat_bp", __name__)

@chat_bp.route("/send", methods=["POST"])
def send_message():
    data = request.get_json() or {}
    user_id = data.get("user_id") or data.get("user")
    message = data.get("message")
    if not message:
        return jsonify({"error":"message is required"}), 400

    # store user message
    save_message(user_id, message, sender="user")

    # call HF
    ai_reply = query_huggingface(message)

    # store ai reply
    save_message(user_id, ai_reply, sender="ai")

    return jsonify({"reply": ai_reply})

@chat_bp.route("/history", methods=["GET"])
def history():
    user_id = request.args.get("user_id") or request.args.get("user")
    if not user_id:
        return jsonify({"error":"user_id required"}), 400
    messages = get_chat_history(user_id)
    return jsonify({"messages": messages})
