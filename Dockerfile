# STAGE 1: The "Builder"
# This stage will have all the tools needed to compile the tokenizers package.
FROM python:3.10 as builder

# Set the working directory
WORKDIR /app

# Install the Rust toolchain, which is required to compile tokenizers
ENV PATH="/root/.cargo/bin:${PATH}"
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain stable

# Create and activate a virtual environment
ENV VIRTUAL_ENV=/app/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Copy requirements and install them into the virtual environment
# This will compile tokenizers for the correct architecture and install all other packages.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# STAGE 2: The "Runner"
# This is the small, final image that will run the application.
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Copy the virtual environment from the builder stage.
# This contains our perfectly compiled packages.
COPY --from=builder /app/venv /app/venv

# Copy the application code
COPY . .

# Set the PATH to use the python from our virtual environment
ENV PATH="/app/venv/bin:$PATH"

# Expose the port and run the application. 
# This now correctly points to the application object in src/main.py
EXPOSE 10000
CMD ["gunicorn", "--workers", "2", "--bind", "0.0.0.0:10000", "src.main:app"]
