# app/routes/chat_routes.py
from flask import Blueprint, request, jsonify
from app.services.ai_service import save_message, get_chat_history, query_huggingface, get_user_message_count_today

chat_bp = Blueprint("chat_bp", __name__)

@chat_bp.route("/send", methods=["POST", "OPTIONS"])
def send_message():
    if request.method == "OPTIONS":
        return _build_cors_preflight_response()

    try:
        data = request.get_json() or {}
        print(f"📨 Received request data: {data}")

        user_id = data.get("user_id") or data.get("user")
        message = data.get("message")

        if not message or not message.strip():
            return jsonify({"error": "Message is required"}), 400
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        # Clean the message
        message = message.strip()

        # Store user message
        save_message(user_id, message, sender="user")

        # Get AI reply with user_id for daily limit check
        print(f"🔍 Processing message from user {user_id}: {message}")
        ai_reply = query_huggingface(message, user_id)

        # Store AI reply
        save_message(user_id, ai_reply, sender="ai")

        # Get current usage
        message_count = get_user_message_count_today(user_id)

        response = jsonify({
            "reply": ai_reply,
            "user_id": user_id,
            "daily_usage": message_count,
            "remaining_messages": max(0, 20 - message_count),
            "status": "success"
        })

        return _corsify_actual_response(response)

    except Exception as e:
        print(f"💥 Error in send_message: {e}")
        error_response = jsonify({
            "error": "Internal server error",
            "reply": "I'm experiencing technical difficulties. Please try again shortly."
        })
        return _corsify_actual_response(error_response), 500

@chat_bp.route("/history", methods=["GET", "OPTIONS"])
def history():
    if request.method == "OPTIONS":
        return _build_cors_preflight_response()

    user_id = request.args.get("user_id") or request.args.get("user")
    if not user_id:
        return jsonify({"error": "user_id required"}), 400

    messages = get_chat_history(user_id)
    response = jsonify({"messages": messages})
    return _corsify_actual_response(response)

@chat_bp.route("/usage", methods=["GET", "OPTIONS"])
def get_usage():
    """Get user's daily message count"""
    if request.method == "OPTIONS":
        return _build_cors_preflight_response()

    user_id = request.args.get("user_id")
    if not user_id:
        return jsonify({"error": "user_id required"}), 400

    message_count = get_user_message_count_today(user_id)
    response = jsonify({
        "user_id": user_id,
        "daily_messages_used": message_count,
        "daily_limit": 20,
        "remaining_messages": max(0, 20 - message_count)
    })
    return _corsify_actual_response(response)

def _build_cors_preflight_response():
    response = jsonify({"status": "preflight"})
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Headers", "*")
    response.headers.add("Access-Control-Allow-Methods", "*")
    return response

def _corsify_actual_response(response):
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response