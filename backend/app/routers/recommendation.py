# backend/app/routers/recommendation.py
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app import crud, ai_matching as ai_match
from app.redis_client import redis_client
import json

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/")
def get_recommendations(user_id: int, db: Session = Depends(get_db)):
    # Retrieve all swap posts from the database
    posts = crud.get_swap_posts(db)
    # Try to get recommendations from Redis cache
    cache_key = f"recommendations:{user_id}"
    cached = redis_client.get(cache_key)
    if cached:
        recommendations = json.loads(cached)
    else:
        recommendations = ai_match.compute_recommendations(user_id, posts)
        # Cache the recommendations for 300 seconds
        redis_client.setex(cache_key, 300, json.dumps(recommendations))
    return {"recommended_post_ids": recommendations}
