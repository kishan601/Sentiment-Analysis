# Use the full, standard Python runtime as a parent image
FROM python:3.10

# Set the working directory in the container
WORKDIR /app

# Install PyTorch separately from the official source for CPU
RUN pip install torch==1.13.1+cpu --extra-index-url https://download.pytorch.org/whl/cpu

# Copy the requirements file and install the rest of the dependencies.
# Because we are pre-installing a binary version of `tokenizers`, the `transformers`
# installation will not try to build it from source, avoiding the Rust error.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application's code
COPY . .

# Expose a port to allow Render to map it.
EXPOSE 10000
