#!/bin/bash

# Cybersecurity Backend Start Script for Production
# This script starts the Flask backend using Gunicorn with eventlet worker

# Navigate to backend directory
cd "$(dirname "$0")/backend"

# Activate virtual environment
source .venv/bin/activate

# Start Gunicorn with eventlet worker for Socket.IO support
# - eventlet worker class for WebSocket/Socket.IO support
# - 1 worker (eventlet doesn't support multiple workers well)
# - Bind to all interfaces on port 5000
# - Timeout set to 120 seconds for long-running requests
gunicorn \
    --worker-class eventlet \
    -w 1 \
    --bind 0.0.0.0:5000 \
    --timeout 120 \
    --access-logfile - \
    --error-logfile - \
    --log-level info \
    app:app
