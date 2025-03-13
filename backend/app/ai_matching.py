# backend/app/ai_match.py
from app import schemas
from typing import List
import random

def compute_recommendations(user_id: int, posts: list) -> List[int]:
    """
    Compute recommendation results based on the current user and all swap posts.
    In this placeholder, simply return a random list of swap post IDs that are not owned by the user.
    """
    if not posts:
        return []
    post_ids = [post.id for post in posts if post.owner_id != user_id]
    # Return up to 5 recommended results
    recommendations = random.sample(post_ids, min(len(post_ids), 5))
    return recommendations
