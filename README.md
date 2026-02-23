# Text Classification Micro-service

This project is a simple text classification micro-service that uses a pre-trained model to predict the sentiment of a given text.

## Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd <project-directory>
   ```
3. Create a virtual environment:
   ```bash
   python3 -m venv .venv
   ```
4. Activate the virtual environment:
   ```bash
   source .venv/bin/activate
   ```
5. Install the dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Running the API

To run the API, execute the following command:

```bash
python3 src/main.py
```

The API will be available at `http://127.0.0.1:5000`.

## Running Tests

To run the tests, execute the following command:

```bash
pytest
```
