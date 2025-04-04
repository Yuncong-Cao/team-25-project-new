import pandas as pd
from embedding_utils import get_embedding
from chromadb_instance import collection
from sklearn.metrics.pairwise import cosine_similarity

def load_course_data(file_path):
    data = pd.read_csv(file_path)
    data.columns = data.columns.str.strip().str.lower()
    data["id"] = data.apply(lambda x: f"{x['course']}_{x['name']}", axis=1)

    print("Start generating course vectors...")
    clean_data = []
    clean_embeddings = []

    for _, row in data.iterrows():
        embedding = get_embedding(row['course'])
        if embedding is not None:
            clean_data.append(row)
            clean_embeddings.append(embedding)

    data = pd.DataFrame(clean_data)

    collection.add(
        ids=data["id"].tolist(),
        embeddings=clean_embeddings,
        documents=data["course"].tolist(),
        metadatas=data[["name", "star", "status"]].to_dict(orient="records")
    )
    return data, clean_embeddings

def find_matches(data, embeddings):
    matches = []
    for i in range(len(data)):
        for j in range(i + 1, len(data)):
            if data.iloc[i]['course'] == data.iloc[j]['course']:
                if data.iloc[i]['status'] != data.iloc[j]['status']:
                    if abs(data.iloc[i]['star'] - data.iloc[j]['star']) <= 1:
                        sim = cosine_similarity([embeddings[i]], [embeddings[j]])[0][0]
                        if sim > 0.85:
                            matches.append([
                                data.iloc[i]['name'],
                                data.iloc[j]['name'],
                                data.iloc[i]['course']
                            ])
    return matches
