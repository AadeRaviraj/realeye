'''
Name : Aade Raviraj Shankar
Code date : 01 - 09 - 2025
file name : run.py
purpose :  To start the flask app host on the render for free hosting 

'''

from app import create_app

app = create_app()  

if __name__ == "__main__":
    import os
    port = int(os.environ.get('PORT', 5000))

    print("🚀 Starting Realeye Study App Backend...")
    print(f"📍 Environment: {'Production' if not app.debug else 'Development'}")
    print(f"🔗 Port: {port}")
    print("📚 Features: AI Chat, Study Materials, Progress Tracking")

    app.run(host='0.0.0.0', port=port, debug=False)
    # import os
    # port = int(os.environ.get('PORT', 5000))
    # app.run(host='0.0.0.0', port=port, debug=False)
    # app.run(debug=True)

