import os
from dotenv import load_dotenv


load_dotenv()


CLOUDINARY_CLOUD_NAME = os.getenv("CLOUDINARY_CLOUD_NAME")
CLOUDINARY_API_KEY = os.getenv("CLOUDINARY_API_KEY")
CLOUDINARY_API_SECRET = os.getenv("CLOUDINARY_API_SECRET")
MAX_IMAGE_SIZE_MB = 1

class Config:
    ASTRA_DB_APPLICATION_TOKEN = os.getenv("ASTRA_DB_APPLICATION_TOKEN")
    ASTRA_DB_API_ENDPOINT = os.getenv("ASTRA_DB_API_ENDPOINT")
    
    
    HUGGINGFACE_API_TOKEN = os.getenv("HUGGINGFACE_API_TOKEN")
    HF_MODEL = os.getenv("HF_MODEL", "microsoft/DialoGPT-medium")

# Optional aliases for old references
# ASTRA_DB_TOKEN = Config.ASTRA_DB_APPLICATION_TOKEN
# HF_API_TOKEN = Config.HUGGINGFACE_API_TOKEN
#
#
# print("Loaded ASTRA Token:", Config.ASTRA_DB_APPLICATION_TOKEN)
# print("Loaded API Endpoint:", Config.ASTRA_DB_API_ENDPOINT)
