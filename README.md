# Enterprise-Grade Sentiment Analysis Microservice

![Python Version](https://img.shields.io/badge/python-3.10-blue.svg)
![Framework](https://img.shields.io/badge/Framework-Flask-red.svg)
![Deployment](https://img.shields.io/badge/Deploy%20To-Render-lightgrey.svg)

---

## 1. Executive Summary

In today's data-centric landscape, understanding customer voice is paramount. This project provides a scalable, reliable, and high-performance **Sentiment Analysis Microservice** designed to deliver actionable insights from text data. 

Built with a production-first mindset, it leverages a state-of-the-art machine learning model, is containerized for maximum portability, and is configured for seamless deployment in a modern cloud environment. This service acts as a foundational component for applications requiring real-time text understanding, from customer feedback analysis to social media monitoring.

**Repository Link:** [https://github.com/kishan601/Sentiment-Analysis.git](https://github.com/kishan601/Sentiment-Analysis.git)

---

## 2. System Architecture & Technology Stack

This service is designed as a self-contained, containerized application, ensuring consistency across development, testing, and production environments.

### High-Level Design

```mermaid
graph TD
    A[Client] -- "HTTP POST Request<br/>(application/json)" --> B(Gunicorn WSGI Server);
    B -- Forwards Request --> C(Flask Application);
    C -- "Processes Request" --> D[Sentiment Analysis Model <br/>(DistilBERT)];
    D -- "Returns Prediction (Label, Score)" --> C;
    C -- "JSON Response" --> A;

    style A fill:#e0e0e0,stroke:#333,stroke-width:2px
    style B fill:#415a77,stroke:#fff,stroke-width:2px
    style C fill:#415a77,stroke:#fff,stroke-width:2px
    style D fill:#00b4d8,stroke:#fff,stroke-width:2px
```

The data flows through the system as follows:
1.  A **Client** sends an HTTP `POST` request with a JSON payload containing the text to the API endpoint.
2.  The request is received by the **Gunicorn** WSGI server, which is the production-ready interface to the application.
3.  **Flask**, our web framework, receives the request from Gunicorn and routes it to the prediction logic.
4.  The pre-loaded **DistilBERT model** performs inference on the text to determine the sentiment.
5.  The resulting prediction (the label and confidence score) is formatted into a **JSON response** by Flask and sent back to the client.

### Technology Stack

| Component             | Technology                                                                | Rationale                                                                        |
| --------------------- | ------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | 
| **ML Model**          | `distilbert-base-uncased-finetuned-sst-2-english` (from Hugging Face) | Provides an excellent balance of high accuracy and low-latency inference.        |
| **Web Framework**     | Flask                                                                     | A lightweight and flexible framework for building robust APIs.                   |
| **WSGI Server**       | Gunicorn                                                                  | A production-ready server that provides stability and performance.               |
| **Containerization**  | Docker                                                                    | Ensures environment consistency and simplifies deployment.                       |
| **Deployment**        | Render                                                                    | A cloud platform that simplifies a Git-to-deploy workflow, ideal for containers. |
| **Testing**           | Pytest                                                                    | A powerful and easy-to-use testing framework for ensuring code quality.          |

---

## 3. Project Structure Deep Dive

```
.
├── Dockerfile
├── README.md
├── render.yaml
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

-   **`Dockerfile`**: Defines a **multi-stage build process**. 
    1.  The `builder` stage installs the Rust toolchain and compiles the `tokenizers` library from source for the target architecture. 
    2.  The final `runner` stage is a slim image that copies the pre-compiled dependencies and application code, resulting in a small, secure, and efficient production container.
-   **`render.yaml`**: An "Infrastructure as Code" file that declaratively defines the service on Render. It instructs Render to build the service from the `Dockerfile` and configures the web service environment.
-   **`src/main.py`**: The application's entry point. It initializes the Flask app, loads the ML model on startup (to prevent a cold start on every request), and defines the API routes:
    -   `/`: Serves a simple HTML interface for interactive demonstrations.
    -   `/predict`: The core API endpoint for handling sentiment analysis predictions.
-   **`src/model.py`**: Decouples the model loading logic from the web server logic. It is responsible for downloading and caching the pre-trained model and tokenizer from Hugging Face's model hub.
-   **`tests/test_api.py`**: A suite of automated tests that validate the `/predict` endpoint, ensuring it handles valid requests correctly and provides responses in the expected format. This is crucial for CI/CD pipelines.

---

## 4. API Specification

### Endpoint: `/predict`

-   **Method:** `POST`
-   **Description:** Analyzes the sentiment of a given text string.
-   **Headers:** `Content-Type: application/json`

#### Request Body

| Field  | Type   | Description                      | Required |
| ------ | ------ | -------------------------------- | -------- |
| `text` | String | The text you wish to analyze.    | Yes      |

*Example:*
'''json
{
  "text": "This new feature is incredibly intuitive and well-designed."
}
'''

#### Responses

-   **`200 OK` (Success)**

    Returns the predicted label and a confidence score.

    *Example:*
    '''json
    {
      "label": "POSITIVE",
      "score": 0.9999
    }
    '''

-   **`400 Bad Request` (Client Error)**

    Returned if the `text` field is missing or the payload is not valid JSON.

    *Example:*
    '''json
    {
      "error": "Invalid request. Please provide 'text' in the JSON payload."
    }
    '''

---

## 5. Deployment & Operations

### Deployment to Render

Deployment is automated via the `render.yaml` file.

1.  Connect your GitHub repository to Render.
2.  Create a new "Blueprint" service, and Render will automatically detect and use the `render.yaml`.
3.  Render will execute the multi-stage `Dockerfile` build, deploy the container, and make the service live.

The `startCommand` in the `render.yaml` overrides the `Dockerfile`'s `CMD` to provide a single source of truth for the production run command.

### Local Development

(Instructions for local setup remain the same for developers on the team).

---

## 6. Project Roadmap & Future Enhancements

To further enhance the value of this microservice, the following improvements are planned:

-   **Batch Prediction Endpoint:** Introduce a `/predict/batch` endpoint to allow for the analysis of multiple texts in a single API call, significantly improving efficiency for bulk processing.
-   **Expanded Model Support:** Integrate logic to switch between different models (e.g., for different languages or domains) via an API parameter.
-   **Enhanced Logging & Monitoring:** Integrate with a logging service (like Logstash or Datadog) to provide better observability into API performance and errors.
-   **Model Retraining Pipeline:** Develop a CI/CD pipeline to automate the process of fine-tuning and deploying updated versions of the model as new data becomes available.
