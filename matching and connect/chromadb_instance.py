import chromadb
import os

persist_dir = "./course_db"
os.makedirs(persist_dir, exist_ok=True)

client = chromadb.Client(
    settings=chromadb.Settings(persist_directory=persist_dir)
)
collection = client.get_or_create_collection(
    name="courses",
    metadata={"dimension": 1536}
)