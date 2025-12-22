import json
from datetime import datetime

def handler(event, context):
    print("Logging metrics...")
    print("Input event:", json.dumps(event))

    # Умовні "метрики"
    metrics = {
        "accuracy": 0.9,
        "loss": 0.1,
        "timestamp": datetime.utcnow().isoformat() + "Z"
    }

    result = {
        "step": "log_metrics",
        "metrics": metrics,
        "received": event
    }
    print("Metrics:", json.dumps(metrics))
    return result
