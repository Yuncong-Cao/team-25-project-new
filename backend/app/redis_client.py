# backend/app/redis_client.py
import redis
import os

# Redis URL can be configured via environment variable
REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379/0")
redis_client = redis.Redis.from_url(REDIS_URL)
