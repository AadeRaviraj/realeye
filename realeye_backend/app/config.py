'''

Name : Aade Raviraj Shankar
Code date : 01 - 09 - 2025
file name : config.py
purpose :  To to secure the api keys and cloud name 

'''
import os
from dotenv import load_dotenv

load_dotenv()

CLOUDINARY_CLOUD_NAME = os.getenv("ddey92jwh")
CLOUDINARY_API_KEY = os.getenv("343317979346182")
CLOUDINARY_API_SECRET = os.getenv("oOn5uo7v0m93z0PgTPFDMSaoaPg")
MAX_IMAGE_SIZE_MB = 1  # 1MB
