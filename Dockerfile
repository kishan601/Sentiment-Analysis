# Use the full, standard Python runtime as a parent image
FROM python:3.10

# Set the working directory in the container
WORKDIR /app

# Install PyTorch separately from the official source for CPU
RUN pip install torch==1.13.1+cpu --extra-index-url https://download.pytorch.org/whl/cpu

# Copy the requirements file
COPY requirements.txt .

# Install all dependencies in a single step.
# Pip will install the tokenizers wheel from the URL in the requirements file first,
# which satisfies the dependency for transformers before it is installed.
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application's code
COPY . .

# Expose a port to allow Render to map it.
EXPOSE 10000
