# backend/app/crud.py
from sqlalchemy.orm import Session
from app import models, schemas
from typing import List

# User operations
def create_user(db: Session, user: schemas.UserCreate, hashed_password: str):
    db_user = models.User(username=user.username, email=user.email, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_user_by_email(db: Session, email: str):
    return db.query(models.User).filter(models.User.email == email).first()

def get_user(db: Session, user_id: int):
    return db.query(models.User).filter(models.User.id == user_id).first()

# Swap post operations
def create_swap_post(db: Session, post: schemas.SwapPostCreate, owner_id: int):
    db_post = models.SwapPost(**post.dict(), owner_id=owner_id)
    db.add(db_post)
    db.commit()
    db.refresh(db_post)
    return db_post

def get_swap_post(db: Session, post_id: int):
    return db.query(models.SwapPost).filter(models.SwapPost.id == post_id).first()

def get_swap_posts(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.SwapPost).offset(skip).limit(limit).all()

def update_swap_post_status(db: Session, post_id: int, status: str):
    db_post = get_swap_post(db, post_id)
    if db_post:
        db_post.status = status
        db.commit()
        db.refresh(db_post)
    return db_post

# Transaction operations
def create_swap_transaction(db: Session, transaction: schemas.SwapTransactionCreate):
    db_transaction = models.SwapTransaction(**transaction.dict())
    db.add(db_transaction)
    db.commit()
    db.refresh(db_transaction)
    return db_transaction

def get_swap_transaction(db: Session, transaction_id: int):
    return db.query(models.SwapTransaction).filter(models.SwapTransaction.id == transaction_id).first()

def confirm_transaction_by_owner(db: Session, transaction_id: int):
    db_transaction = get_swap_transaction(db, transaction_id)
    if db_transaction:
        db_transaction.confirmed_by_owner = True
        if db_transaction.confirmed_by_counter:
            db_transaction.status = "completed"
        db.commit()
        db.refresh(db_transaction)
    return db_transaction

def confirm_transaction_by_counter(db: Session, transaction_id: int):
    db_transaction = get_swap_transaction(db, transaction_id)
    if db_transaction:
        db_transaction.confirmed_by_counter = True
        if db_transaction.confirmed_by_owner:
            db_transaction.status = "completed"
        db.commit()
        db.refresh(db_transaction)
    return db_transaction

def get_user_transactions(db: Session, user_id: int) -> List[models.SwapTransaction]:
    # Retrieve transactions for swap posts owned by the user
    return db.query(models.SwapTransaction).join(models.SwapPost, models.SwapTransaction.post_id == models.SwapPost.id)\
           .filter(models.SwapPost.owner_id == user_id).all()
