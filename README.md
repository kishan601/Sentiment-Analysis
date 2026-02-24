# 🚀 Enterprise-Grade Sentiment Analysis Microservice

![Python Version](https://img.shields.io/badge/python-3.10-blue.svg)
![Framework](https://img.shields.io/badge/Framework-Flask-red.svg)
![Deployment](https://img.shields.io/badge/Deploy-HuggingFace%20Spaces-yellow.svg)
![Containerized](https://img.shields.io/badge/Container-Docker-blue.svg)

---

## 1️⃣ Executive Summary

In today’s data-driven ecosystem, extracting actionable insights from textual data is critical. This project delivers a scalable, production-ready **Sentiment Analysis Microservice** capable of real-time inference with high accuracy and low latency.

The service is:

* ✅ Built using a state-of-the-art Transformer model
* ✅ Fully containerized with Docker
* ✅ Production-served via Gunicorn
* ✅ Live deployed on Hugging Face Spaces
* ✅ Designed with modular architecture and testing support

It serves as a foundational AI component for platforms involving:

* Customer feedback analytics
* Product review classification
* Social media monitoring
* Internal ticket prioritization

---

### 🔗 Live Demo

👉 [https://huggingface.co/spaces/kishank6290/sentiment-analysis-demo](https://huggingface.co/spaces/kishank6290/sentiment-analysis-demo)

### 📂 GitHub Repository

👉 [https://github.com/kishan601/Sentiment-Analysis](https://github.com/kishan601/Sentiment-Analysis)

---

## 2️⃣ System Architecture & Technology Stack

This microservice follows a containerized, production-first design to ensure environment consistency and operational reliability.

### 🔁 High-Level Request Flow

1. A **Client** sends an HTTP `POST` request with JSON payload.
2. **Gunicorn** receives the request as the WSGI production server.
3. **Flask** routes the request to the inference handler.
4. The pre-loaded **DistilBERT model** performs sentiment prediction.
5. A structured **JSON response** is returned to the client.

---

## 🏗 Technology Stack

| Layer                | Technology                                        | Rationale                                    |
| -------------------- | ------------------------------------------------- | -------------------------------------------- |
| **ML Model**         | `distilbert-base-uncased-finetuned-sst-2-english` | High accuracy with optimized inference speed |
| **Model Hub**        | Hugging Face                                      | Reliable model hosting & version control     |
| **Web Framework**    | Flask                                             | Lightweight, flexible API framework          |
| **WSGI Server**      | Gunicorn                                          | Production-grade concurrency handling        |
| **Containerization** | Docker (Multi-stage build)                        | Portability & clean production image         |
| **Deployment**       | Hugging Face Spaces (Docker)                      | ML-native hosting platform                   |
| **Testing**          | Pytest                                            | Automated endpoint validation                |

---

## 3️⃣ Project Structure

```text
.
├── Dockerfile
├── README.md
├── requirements.txt
├── src
│   ├── __init__.py
│   ├── main.py
│   ├── model.py
│   └── templates
│       └── index.html
└── tests
    ├── conftest.py
    └── test_api.py
```

### 🔍 Key Components

### `Dockerfile`

Implements a **multi-stage build**:

**Builder Stage**

* Installs Rust toolchain (required for `tokenizers`)
* Compiles dependencies
* Creates virtual environment

**Runner Stage**

* Uses lightweight `python:3.10-slim`
* Copies pre-built dependencies
* Runs Gunicorn on port `7860` (HF requirement)

This results in:

* Smaller final image
* Faster startup
* Clean production environment

---

### `src/main.py`

* Initializes Flask app
* Loads model at startup (prevents per-request cold start)
* Defines routes:

  * `/` → Interactive frontend UI
  * `/predict` → API inference endpoint

---

### `src/model.py`

* Downloads and caches model
* Handles inference logic
* Decoupled from web layer for clean architecture

---

### `tests/`

* Validates `/predict` behavior
* Ensures response structure correctness
* Prepares codebase for CI/CD integration

---

## 4️⃣ API Specification

### Endpoint: `/predict`

**Method:** `POST`
**Content-Type:** `application/json`

---

### Request Body

| Field | Type   | Required | Description                       |
| ----- | ------ | -------- | --------------------------------- |
| text  | String | Yes      | Input text for sentiment analysis |

#### Example Request

```json
{
  "text": "This new feature is incredibly intuitive and well-designed."
}
```

---

### Success Response — `200 OK`

```json
{
  "label": "POSITIVE",
  "score": 0.9999
}
```

---

### Error Response — `422 Unprocessable Entity`

```json
{
  "error": "Missing 'text' in request body"
}
```

---

## 5️⃣ Deployment & Operations

### 🌍 Deployment Platform: Hugging Face Spaces (Docker)

The service is deployed using:

* Docker container build
* Gunicorn production server
* Port binding to `7860`

---

### 🖥 Local Development

```bash
git clone https://github.com/kishan601/Sentiment-Analysis.git
cd Sentiment-Analysis
python -m venv venv
source venv/bin/activate  # Windows: venv\\Scripts\\activate
pip install -r requirements.txt
python src/main.py
```

App will run locally at:

```text
http://127.0.0.1:5000
```

---

## 6️⃣ Production Considerations

* Model loads once at startup (reduces latency)
* Single worker configuration (memory-optimized)
* Stateless design (horizontal scaling ready)
* Clean separation between inference and API layer

---

## 7️⃣ Roadmap & Future Enhancements

* 🔹 Batch Prediction Endpoint (`/predict/batch`)
* 🔹 Multi-model switching via API parameter
* 🔹 Structured logging integration
* 🔹 Model retraining CI/CD pipeline
* 🔹 Rate limiting & authentication layer
* 🔹 Docker image optimization (distroless base)

---

## 8️⃣ Key Takeaways

This project demonstrates:

* Production-ready ML deployment
* Container-based microservice architecture
* Real-time NLP inference
* Cloud deployment troubleshooting and optimization
* Clean modular engineering practices

It is not just a demo — it is a deployable AI microservice blueprint.
