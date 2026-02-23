#!/bin/sh
source .venv/bin/activate
# Run the flask app on host 0.0.0.0 and on the port specified by the PORT environment variable, defaulting to 8080
python -u -m flask --app src.main run --debugger --host 0.0.0.0 --port ${PORT:-8080}
