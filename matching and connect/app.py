from flask import Flask, request, jsonify
from flask_cors import CORS
import datetime, os
from embedding_utils import get_embedding
from chromadb_instance import collection

app = Flask(__name__)
CORS(app)

@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")

    if password == "123456":
        timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        content = f"User {email} logged in at {timestamp}."
        file_path = os.path.join("./course_db", f"{email}_login.txt")
        with open(file_path, "w") as f:
            f.write(content)

        embedding = get_embedding(content)
        if embedding:
            collection.add(
                ids=[f"{email}_login_{timestamp}"],
                embeddings=[embedding],
                documents=[content],
                metadatas=[{"email": email, "event": "login", "timestamp": timestamp}]
            )

        return jsonify({
            "message": "Login successful",
            "token": "mock-token-123",
            "user": {
                "id": email,
                "email": email,
                "name": email.split('@')[0]
            }
        }), 200
    else:
        return jsonify({"message": "Invalid credentials"}), 401

if __name__ == '__main__':
    from matching_engine import load_course_data, find_matches

    print("Loading course data and generating matches...")
    file_path = "/Users/andyli/Desktop/222/Course_Data.csv"
    data, embeddings = load_course_data(file_path)
    matches = find_matches(data, embeddings)

    print("\nMatching Results:")
    if matches:
        for match in matches:
            print(f"➡️ {match[0]} - {match[1]} ({match[2]})")
    else:
        print("No matches found.")

    print("\nLeft in DB:")
    print(collection.get())

    print("\nFlask server running...")
    app.run(debug=True)
