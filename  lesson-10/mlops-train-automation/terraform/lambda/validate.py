import json

def handler(event, context):
    print("Validating data...")
    print("Input event:", json.dumps(event))

    # Умовна "валідація"
    ok = True

    result = {
        "step": "validate",
        "ok": ok,
        "received": event
    }
    return result
