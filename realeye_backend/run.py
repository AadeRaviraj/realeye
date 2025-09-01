'''
Name : Aade Raviraj Shankar
Code date : 01 - 09 - 2025
file name : run.py
purpose :  To start the flask app host on the render for free hosting 

'''

from app import create_app

app = create_app()  

if __name__ == "__main__":
    app.run(debug=True)

