from flask import Flask, request, jsonify
from src.model import predict, load_model, MODEL_NAME

app = Flask(__name__)

@app.before_first_request
def before_first_request():
    """Load the model before the first request."""
    load_model()

@app.route("/predict", methods=["POST"])
def predict_endpoint():
    """
    The prediction endpoint.

    Accepts JSON input like:
    {"text": "I love this product"}

    Returns a JSON response with the prediction label, confidence score, and model name.
    """
    if not request.json or "text" not in request.json:
        return jsonify({"error": "Missing 'text' in request body"}), 422

    text = request.json["text"]
    prediction = predict(text)

    if "error" in prediction:
        return jsonify(prediction), 422

    return jsonify(prediction)

if __name__ == "__main__":
    app.run(debug=True)
