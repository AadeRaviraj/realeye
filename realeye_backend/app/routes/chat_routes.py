from flask import Blueprint, request, jsonify
from app.services.ai_service import (
    save_message,
    get_chat_history,
    get_ai_response,
    get_user_message_count_today,
)

chat_bp = Blueprint("chat_bp", __name__)

@chat_bp.route("/send", methods=["POST"])
def send_message():
    try:
        data = request.get_json() or {}
        user_id = data.get("user_id")
        message = data.get("message", "").strip()

        if not message:
            return jsonify({"error": "Message is required"}), 400
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

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

    except Exception as e:
        print(f" Chat send error: {e}")
        return jsonify({
            "error": "Server error",
            "reply": "AI is having trouble right now. Please try again.",
            "status": "error"
        }), 500
