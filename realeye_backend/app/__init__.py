from flask import Flask, jsonify
from flask_cors import CORS

def create_app():
    app = Flask(__name__)
    CORS(app)

    # Import routes
    from app.routes.image_routes import image_bp
    app.register_blueprint(image_bp, url_prefix='/api')

    # Register chat routes
    from app.routes.chat_routes import chat_bp
    app.register_blueprint(chat_bp, url_prefix='/api/chat')

    @app.route('/')
    def home():
        return jsonify({
            "status": "success",
            "message": "Realeye Study App Backend is running successfully! ",
            "version": "2.0",
            "features": ["AI Chat Assistant", "Daily Message Limits"],
            "endpoints": {
                "chat": {
                    "send_message": "POST /api/chat/send",
                    "get_history": "GET /api/chat/history",
                    "get_usage": "GET /api/chat/usage"
                }
            }
        })

    @app.route('/health')
    def health_check():
        return jsonify({"status": "healthy", "service": "Realeye Backend"})

    return app