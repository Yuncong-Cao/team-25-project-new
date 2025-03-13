# backend/app/models.py
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Text, Float, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    hashed_password = Column(String, nullable=False)
    rating = Column(Float, default=5.0)

    # Relationship with swap posts
    swap_posts = relationship("SwapPost", back_populates="owner")
    transactions = relationship("SwapTransaction", back_populates="user", foreign_keys="SwapTransaction.id")

class SwapPost(Base):
    __tablename__ = "swap_posts"
    id = Column(Integer, primary_key=True, index=True)
    course_name = Column(String, index=True, nullable=False)
    exam_time = Column(String, index=True, nullable=False)  # Can be changed to DateTime if needed
    description = Column(Text)
    status = Column(String, default="open")  # Status: open, matched, closed, etc.
    owner_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

    owner = relationship("User", back_populates="swap_posts")
    # One-to-one relationship with transaction (one swap post can be involved in one transaction)
    transaction = relationship("SwapTransaction", back_populates="swap_post", uselist=False)

class SwapTransaction(Base):
    __tablename__ = "swap_transactions"
    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(Integer, ForeignKey("swap_posts.id"), nullable=False)
    counter_post_id = Column(Integer, ForeignKey("swap_posts.id"), nullable=False)
    confirmed_by_owner = Column(Boolean, default=False)
    confirmed_by_counter = Column(Boolean, default=False)
    status = Column(String, default="pending")  # Status: pending, completed, cancelled
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships to both swap posts involved in the transaction
    swap_post = relationship("SwapPost", foreign_keys=[post_id], back_populates="transaction")
    counter_post = relationship("SwapPost", foreign_keys=[counter_post_id])
