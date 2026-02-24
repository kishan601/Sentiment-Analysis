from transformers import pipeline

MODEL_NAME = "cardiffnlp/twitter-roberta-base-sentiment"
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

    # This model uses labels like 'LABEL_0', 'LABEL_1', 'LABEL_2'.
    # We'll map them to human-readable names.
    # From the model's documentation: 0 -> Negative, 1 -> Neutral, 2 -> Positive
    label_map = {
        "LABEL_0": "NEGATIVE",
        "LABEL_1": "NEUTRAL",
        "LABEL_2": "POSITIVE"
    }
    
    readable_label = label_map.get(prediction["label"], prediction["label"].upper())

    return {
        "label": readable_label,
        "score": prediction["score"],
        "model_name": MODEL_NAME
    }
