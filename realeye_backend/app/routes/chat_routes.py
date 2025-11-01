from flask import Blueprint, request, jsonify
from app.services.ai_services import save_message, get_chat_history, get_ai_response, get_user_message_count_today

chat_bp = Blueprint("chat_bp", __name__)

@chat_bp.route("/send", methods=["POST"])
def send_message():
    data = request.get_json() or {}
    user_id = data.get("user_id")
    message = data.get("message", "").strip()

    if not message or not user_id:
        return jsonify({"error": "Message and user_id are required"}), 400

    save_message(user_id, message, "user")
    ai_reply = get_ai_response(message, user_id)
    save_message(user_id, ai_reply, "ai")

    usage = get_user_message_count_today(user_id)

    return jsonify({
        "reply": ai_reply,
        "user_id": user_id,
        "daily_usage": usage,
        "remaining_messages": max(0, 100 - usage),
        "status": "success"
    })

@chat_bp.route("/history", methods=["GET"])
def history():
    user_id = request.args.get("user_id")
    if not user_id:
        return jsonify({"error": "user_id required"}), 400

    messages = get_chat_history(user_id)
    return jsonify({"messages": messages})

@chat_bp.route("/usage", methods=["GET"])
def get_usage():
    user_id = request.args.get("user_id")
    if not user_id:
        return jsonify({"error": "user_id required"}), 400

    usage = get_user_message_count_today(user_id)
    return jsonify({
        "user_id": user_id,
        "daily_messages_used": usage,
        "daily_limit": 100,
        "remaining_messages": max(0, 100 - usage)
    })
