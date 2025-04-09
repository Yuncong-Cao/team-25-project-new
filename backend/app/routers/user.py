# backend/app/routers/user.py
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app import schemas, crud
from app.database import SessionLocal
from passlib.context import CryptContext

router = APIRouter()
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.post("/register", response_model=schemas.User)
def register_user(user: schemas.UserCreate, db: Session = Depends(get_db)):
    db_user = crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    hashed_password = pwd_context.hash(user.password)
    return crud.create_user(db, user, hashed_password)

@router.get("/{user_id}", response_model=schemas.User)
def read_user(user_id: int, db: Session = Depends(get_db)):
    db_user = crud.get_user(db, user_id=user_id)
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user

# 新增：更新用户评分接口
@router.put("/{user_id}/rating", response_model=schemas.User)
def update_rating(user_id: int, rating_update: schemas.UserRatingUpdate, db: Session = Depends(get_db)):
    db_user = crud.update_user_rating(db, user_id, rating_update.rating)
    if db_user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return db_user
