# backend/app/routers/swap.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import schemas, crud
from app.database import SessionLocal

router = APIRouter()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/", response_model=schemas.SwapPost)
def create_swap_post(post: schemas.SwapPostCreate, db: Session = Depends(get_db)):
    # For now, using a fixed user ID = 1 (should be replaced with actual user authentication later)
    owner_id = 1
    return crud.create_swap_post(db, post, owner_id)

@router.get("/", response_model=list[schemas.SwapPost])
def read_swap_posts(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    posts = crud.get_swap_posts(db, skip, limit)
    return posts

@router.get("/{post_id}", response_model=schemas.SwapPost)
def read_swap_post(post_id: int, db: Session = Depends(get_db)):
    db_post = crud.get_swap_post(db, post_id)
    if not db_post:
        raise HTTPException(status_code=404, detail="Swap post not found")
    return db_post
