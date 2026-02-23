from transformers import pipeline

MODEL_NAME = "distilbert-base-uncased-finetuned-sst-2-english"
MAX_INPUT_LENGTH = 512

classifier = None

def load_model():
    """Loads the sentiment analysis model."""
    global classifier
    if classifier is None:
        classifier = pipeline("sentiment-analysis", model=MODEL_NAME)

def predict(text: str) -> dict:
    """
    Predicts the sentiment of a given text.

    Args:
        text: The text to analyze.

    Returns:
        A dictionary containing the predicted label and score.
    """
    if not text:
        return {"error": "Input text cannot be empty."}

    if len(text) > MAX_INPUT_LENGTH:
        text = text[:MAX_INPUT_LENGTH]

    if classifier is None:
        load_model()
        
    prediction = classifier(text)[0]
    return {
        "label": prediction["label"],
        "score": prediction["score"],
        "model_name": MODEL_NAME
    }
