# backend/app/schemas.py
from pydantic import BaseModel, EmailStr
from datetime import datetime
from typing import Optional

# User-related schemas
class UserBase(BaseModel):
    username: str
    email: EmailStr

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int
    rating: float

    class Config:
        orm_mode = True

# Swap post-related schemas
class SwapPostBase(BaseModel):
    course_name: str
    exam_time: str
    description: str

class SwapPostCreate(SwapPostBase):
    pass

class SwapPost(SwapPostBase):
    id: int
    owner_id: int
    status: str
    created_at: datetime

    class Config:
        orm_mode = True

# Transaction-related schemas for confirming swap processes
class SwapTransactionBase(BaseModel):
    post_id: int
    counter_post_id: int

class SwapTransactionCreate(SwapTransactionBase):
    pass

class SwapTransaction(SwapTransactionBase):
    id: int
    confirmed_by_owner: bool
    confirmed_by_counter: bool
    status: str
    created_at: datetime

    class Config:
        orm_mode = True
