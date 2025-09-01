from flask import Flask
from flask_cors import CORS

def create_app():
    app = Flask(__name__)
    CORS(app)

    # Import routes
    from app.routes.image_routes import image_bp
    app.register_blueprint(image_bp, url_prefix='/api')

    return app
