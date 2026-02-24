# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set the working directory in the container
WORKDIR /app

# Install Rust compiler, which is needed to build the `tokenizers` package
RUN apt-get update && apt-get install -y rustc cargo && rm -rf /var/lib/apt/lists/*

# Set the Cargo home directory to a writable location
ENV CARGO_HOME=/app/.cargo

# Install PyTorch separately from the official source for CPU
RUN pip install torch==1.13.1+cpu --extra-index-url https://download.pytorch.org/whl/cpu

# Copy the requirements file and install the rest of the dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application's code
COPY . .

# Expose a port to allow Render to map it.
EXPOSE 10000
