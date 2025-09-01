from flask import Blueprint, request, jsonify
from app.services.cloudinary_service import upload_to_cloudinary
from app.config import MAX_IMAGE_SIZE_MB

image_bp = Blueprint('image_bp', __name__)

@image_bp.route('/upload-profile', methods=['POST'])
def upload_profile():
    if 'image' not in request.files:
        return jsonify({"error": "No image provided"}), 400

    image = request.files['image']

    # Size check (MB)
    image.seek(0, 2)  # move to end
    size_mb = image.tell() / (1024 * 1024)
    image.seek(0)  # reset pointer
    if size_mb > MAX_IMAGE_SIZE_MB:
        return jsonify({"error": f"Image must be <= {MAX_IMAGE_SIZE_MB} MB"}), 400

    public_id = request.form.get('user_id', 'default_user')
    result = upload_to_cloudinary(image, public_id)

    if not result.get("secure_url"):
        return jsonify({"error": "Upload failed"}), 500

    return jsonify({"secure_url": result.get("secure_url")})
