import cloudinary
import cloudinary.uploader
from app.config import CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET

# Cloudinary configuration
cloudinary.config(
    cloud_name=CLOUDINARY_CLOUD_NAME,
    api_key=CLOUDINARY_API_KEY,
    api_secret=CLOUDINARY_API_SECRET
)

def upload_to_cloudinary(file, public_id):
    """Uploads file to Cloudinary"""
    try:
        result = cloudinary.uploader.upload(
            file,
            public_id=public_id,
            folder="user_profiles",
            overwrite=True
        )
        return result  # dictionary with secure_url
    except Exception as e:
        print("Cloudinary upload error:", e)
        return {}
