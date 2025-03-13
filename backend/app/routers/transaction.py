# backend/app/routers/transaction.py
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

@router.post("/", response_model=schemas.SwapTransaction)
def create_transaction(transaction: schemas.SwapTransactionCreate, db: Session = Depends(get_db)):
    # Here, you may add validation to check if the swap posts exist and are open
    return crud.create_swap_transaction(db, transaction)

@router.put("/{transaction_id}/confirm_owner", response_model=schemas.SwapTransaction)
def confirm_transaction_owner(transaction_id: int, db: Session = Depends(get_db)):
    transaction = crud.confirm_transaction_by_owner(db, transaction_id)
    if not transaction:
        raise HTTPException(status_code=404, detail="Transaction not found")
    return transaction

@router.put("/{transaction_id}/confirm_counter", response_model=schemas.SwapTransaction)
def confirm_transaction_counter(transaction_id: int, db: Session = Depends(get_db)):
    transaction = crud.confirm_transaction_by_counter(db, transaction_id)
    if not transaction:
        raise HTTPException(status_code=404, detail="Transaction not found")
    return transaction

@router.get("/user/{user_id}", response_model=list[schemas.SwapTransaction])
def get_user_transactions(user_id: int, db: Session = Depends(get_db)):
    transactions = crud.get_user_transactions(db, user_id)
    return transactions
