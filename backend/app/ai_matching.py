# backend/app/ai_match.py
from app import schemas
from typing import List
import random

def compute_recommendations(user_id: int, posts: list) -> List[int]:
    """
    Recommend swap posts not created by the current user.
    Sort posts based on the rating of the post owner (descending),
    and return up to 5 recommended post IDs.
    """
    if not posts:
        return []

    # 过滤掉自己发的帖子
    filtered_posts = [post for post in posts if post.owner_id != user_id]

    # 根据 owner.rating 降序排列，rating 越高越靠前
    sorted_posts = sorted(
        filtered_posts,
        key=lambda post: getattr(post.owner, 'rating', 0),
        reverse=True
    )

    # 返回最多 5 个帖子 ID
    return [post.id for post in sorted_posts[:5]]