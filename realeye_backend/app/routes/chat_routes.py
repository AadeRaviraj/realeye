from flask import Blueprint, request, jsonify
from app.services.ai_service import get_ai_response

chat_bp = Blueprint("chat_bp", __name__)

@chat_bp.route("/send", methods=["POST"])
def send_message():
    try:
        data = request.get_json() or {}
        user_id = data.get("user_id")
        message = data.get("message", "").strip()

        if not message:
            return jsonify({"error": "Message is required"}), 400

        ai_data = get_ai_response(user_id, message)

        if ai_data.get("status") == "LIMIT_EXCEEDED":
            return jsonify({"error": "LIMIT_EXCEEDED"}), 200

        ai_reply = ai_data.get("response")

        return jsonify({
            "response": ai_reply,
            "remaining": 0
        })

    except Exception as e:
        print(f"Chat error: {e}")
        return jsonify({"error": "Server error"}), 500