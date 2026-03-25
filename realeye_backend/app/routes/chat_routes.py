from flask import Blueprint, request, jsonify
from app.services.ai_service import get_ai_response, get_chat_history

chat_bp = Blueprint("chat_bp", __name__)


# ---------------- SEND MESSAGE ----------------
@chat_bp.route("/send", methods=["POST"])
def send_message():
    try:
        data = request.get_json() or {}
        user_id = data.get("user_id")
        message = data.get("message", "").strip()

        if not user_id:
            return jsonify({"error": "User ID required"}), 400

        if not message:
            return jsonify({"error": "Message required"}), 400

        ai_data = get_ai_response(user_id, message)

        if ai_data["status"] == "LIMIT_EXCEEDED":
            return jsonify({
                "error": "LIMIT_EXCEEDED",
                "remaining": 0
            }), 200

        return jsonify({
            "response": ai_data["response"],
            "remaining": ai_data["remaining"]
        })

    except Exception as e:
        print(f"Chat error: {e}")
        return jsonify({"error": "Server error"}), 500


# ---------------- CHAT HISTORY ----------------
@chat_bp.route("/history", methods=["POST"])
def history():
    try:
        data = request.get_json() or {}
        user_id = data.get("user_id")

        if not user_id:
            return jsonify({"error": "User ID required"}), 400

        history = get_chat_history(user_id)

        return jsonify({
            "history": history
        })

    except Exception as e:
        print(f"History error: {e}")
        return jsonify({"error": "Server error"}), 500