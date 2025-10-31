# # app/routes/chat_routes.py
# from flask import Blueprint, request, jsonify
# from app.services.ai_service import save_message, get_chat_history, query_huggingface, get_user_message_count_today
#
# chat_bp = Blueprint("chat_bp", __name__)
#
# @chat_bp.route("/send", methods=["POST", "OPTIONS"])
# def send_message():
#     if request.method == "OPTIONS":
#         return _build_cors_preflight_response()
#
#     try:
#         data = request.get_json() or {}
#         print(f"📨 Received request data: {data}")
#
#         user_id = data.get("user_id") or data.get("user")
#         message = data.get("message")
#
#         if not message or not message.strip():
#             return jsonify({"error": "Message is required"}), 400
#         if not user_id:
#             return jsonify({"error": "User ID is required"}), 400
#
#         # Clean the message
#         message = message.strip()
#
#         # Store user message
#         save_message(user_id, message, sender="user")
#
#         # Get AI reply with user_id for daily limit check
#         print(f"🔍 Processing message from user {user_id}: {message}")
#         ai_reply = query_huggingface(message, user_id)
#
#         # Store AI reply
#         save_message(user_id, ai_reply, sender="ai")
#
#         # Get current usage
#         message_count = get_user_message_count_today(user_id)
#
#         response = jsonify({
#             "reply": ai_reply,
#             "user_id": user_id,
#             "daily_usage": message_count,
#             "remaining_messages": max(0, 20 - message_count),
#             "status": "success"
#         })
#
#         return _corsify_actual_response(response)
#
#     except Exception as e:
#         print(f"💥 Error in send_message: {e}")
#         error_response = jsonify({
#             "error": "Internal server error",
#             "reply": "I'm experiencing technical difficulties. Please try again shortly."
#         })
#         return _corsify_actual_response(error_response), 500
#
# @chat_bp.route("/history", methods=["GET", "OPTIONS"])
# def history():
#     if request.method == "OPTIONS":
#         return _build_cors_preflight_response()
#
#     user_id = request.args.get("user_id") or request.args.get("user")
#     if not user_id:
#         return jsonify({"error": "user_id required"}), 400
#
#     messages = get_chat_history(user_id)
#     response = jsonify({"messages": messages})
#     return _corsify_actual_response(response)
#
# @chat_bp.route("/usage", methods=["GET", "OPTIONS"])
# def get_usage():
#     """Get user's daily message count"""
#     if request.method == "OPTIONS":
#         return _build_cors_preflight_response()
#
#     user_id = request.args.get("user_id")
#     if not user_id:
#         return jsonify({"error": "user_id required"}), 400
#
#     message_count = get_user_message_count_today(user_id)
#     response = jsonify({
#         "user_id": user_id,
#         "daily_messages_used": message_count,
#         "daily_limit": 20,
#         "remaining_messages": max(0, 20 - message_count)
#     })
#     return _corsify_actual_response(response)
#
# def _build_cors_preflight_response():
#     response = jsonify({"status": "preflight"})
#     response.headers.add("Access-Control-Allow-Origin", "*")
#     response.headers.add("Access-Control-Allow-Headers", "*")
#     response.headers.add("Access-Control-Allow-Methods", "*")
#     return response
#
# def _corsify_actual_response(response):
#     response.headers.add("Access-Control-Allow-Origin", "*")
#     return response


from flask import Blueprint, request, jsonify
from app.services.ai_service import save_message, get_chat_history, query_huggingface, get_user_message_count_today

chat_bp = Blueprint("chat_bp", __name__)

@chat_bp.route("/send", methods=["POST", "OPTIONS"])
def send_message():
    """
    Main endpoint for sending messages to AI chatbot
    """
    if request.method == "OPTIONS":
        return _build_cors_preflight_response()

    try:
        # Validate request
        if not request.is_json:
            return jsonify({"error": "Request must be JSON"}), 400

        data = request.get_json() or {}
        user_id = data.get("user_id")
        message = data.get("message", "").strip()

        # Input validation
        if not message:
            return jsonify({"error": "Message cannot be empty"}), 400
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        # Store user message
        save_message(user_id, message, sender="user")

        # Get AI response
        ai_response = query_huggingface(message, user_id)

        # Store AI response
        save_message(user_id, ai_response, sender="ai")

        # Get usage stats
        message_count = get_user_message_count_today(user_id)

        # Return success response
        response_data = {
            "reply": ai_response,
            "user_id": user_id,
            "daily_usage": message_count,
            "daily_limit": 50,
            "remaining_messages": max(0, 50 - message_count),
            "status": "success"
        }

        return _corsify_actual_response(jsonify(response_data))

    except Exception as e:
        print(f"💥 Error in send_message: {str(e)}")
        error_response = {
            "error": "Internal server error",
            "reply": "I'm experiencing some technical difficulties. Please try again in a moment.",
            "status": "error"
        }
        return _corsify_actual_response(jsonify(error_response)), 500

@chat_bp.route("/history", methods=["GET"])
def get_chat_history_route():
    """
    Get chat history for a user
    """
    try:
        user_id = request.args.get("user_id")
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        limit = request.args.get("limit", 50, type=int)
        messages = get_chat_history(user_id, limit)

        return _corsify_actual_response(jsonify({
            "user_id": user_id,
            "messages": messages,
            "count": len(messages),
            "status": "success"
        }))

    except Exception as e:
        print(f"Error getting chat history: {e}")
        return _corsify_actual_response(jsonify({
            "error": "Failed to retrieve chat history",
            "status": "error"
        })), 500

@chat_bp.route("/usage", methods=["GET"])
def get_usage():
    """
    Get user's daily message usage
    """
    try:
        user_id = request.args.get("user_id")
        if not user_id:
            return jsonify({"error": "User ID is required"}), 400

        message_count = get_user_message_count_today(user_id)

        return _corsify_actual_response(jsonify({
            "user_id": user_id,
            "daily_messages_used": message_count,
            "daily_limit": 50,
            "remaining_messages": max(0, 50 - message_count),
            "status": "success"
        }))

    except Exception as e:
        print(f"Error getting usage: {e}")
        return _corsify_actual_response(jsonify({
            "error": "Failed to get usage data",
            "status": "error"
        })), 500

def _build_cors_preflight_response():
    """
    Handle CORS preflight requests
    """
    response = jsonify({"status": "preflight"})
    response.headers.add("Access-Control-Allow-Origin", "*")
    response.headers.add("Access-Control-Allow-Headers", "Content-Type,Authorization")
    response.headers.add("Access-Control-Allow-Methods", "GET,POST,OPTIONS")
    return response

def _corsify_actual_response(response):
    """
    Add CORS headers to actual responses
    """
    response.headers.add("Access-Control-Allow-Origin", "*")
    return response