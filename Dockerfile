# Use the full, standard Python runtime as a parent image
FROM python:3.10

# Set the working directory in the container
WORKDIR /app

# Install PyTorch separately from the official source for CPU
RUN pip install torch==1.13.1+cpu --extra-index-url https://download.pytorch.org/whl/cpu

# Copy the requirements file
COPY requirements.txt .

# Install the dependencies, but ONLY from pre-compiled binary wheels.
# This will prevent pip from trying to build `tokenizers` from source, which has been failing.
# The --verbose flag will give us detailed output on why a specific wheel can't be found.
RUN pip install --no-cache-dir --only-binary :all: -r requirements.txt --verbose

# Copy the rest of the application's code
COPY . .

# Expose a port to allow Render to map it.
EXPOSE 10000
