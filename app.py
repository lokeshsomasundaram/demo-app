from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Flask on Docker!"

if __name__ == '__main__':
    # Bind to all interfaces, port 80
    app.run(host='0.0.0.0', port=80)
