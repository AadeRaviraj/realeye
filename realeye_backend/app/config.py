import os
from dotenv import load_dotenv


load_dotenv()


CLOUDINARY_CLOUD_NAME = os.getenv("CLOUDINARY_CLOUD_NAME")
CLOUDINARY_API_KEY = os.getenv("CLOUDINARY_API_KEY")
CLOUDINARY_API_SECRET = os.getenv("CLOUDINARY_API_SECRET")
MAX_IMAGE_SIZE_MB = 1

class Config:
    GROQ_API_KEY = os.getenv("GROQ_API_KEY")
    ASTRA_DB_APPLICATION_TOKEN = os.getenv("ASTRA_DB_APPLICATION_TOKEN")
    ASTRA_DB_API_ENDPOINT = os.getenv("ASTRA_DB_API_ENDPOINT")

    # # Google Gemini API (FREE)
    # GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")


    # App Settings
    MAX_DAILY_MESSAGES = 100