# backend/app/main.py
from fastapi import FastAPI
from app.database import engine
from app import models
from app.routers import user, swap, transaction, recommendation

app = FastAPI(title="CourseSwap Backend")

# Initialize database tables (for development use; in production, use Alembic for migrations)
models.Base.metadata.create_all(bind=engine)

# Register routers for different modules
app.include_router(user.router, prefix="/users", tags=["Users"])
app.include_router(swap.router, prefix="/swap", tags=["Swap Posts"])
app.include_router(transaction.router, prefix="/transactions", tags=["Transactions"])
app.include_router(recommendation.router, prefix="/recommendation", tags=["Recommendation"])

@app.get("/")
def root():
    return {"message": "Welcome to the CourseSwap backend service!"}
