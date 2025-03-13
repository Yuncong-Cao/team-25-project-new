# Use the official Python image as the base image (recommended to choose a lightweight version)
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the dependency file into the container
COPY requirements.txt .

# Install dependencies
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the project code into the container
COPY . .

# Expose the application port (FastAPI uses port 8000 by default)
EXPOSE 8000

# Startup command: Start the uvicorn server and listen on all network interfaces
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
