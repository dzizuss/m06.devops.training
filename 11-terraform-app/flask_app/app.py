import os
import uuid

import boto3
from botocore.exceptions import ClientError
from flask import Flask, jsonify, request


def build_dynamodb_client() -> boto3.resources.base.ServiceResource:
    endpoint = os.getenv("LOCALSTACK_URL", "http://localhost:4566")
    region = os.getenv("AWS_DEFAULT_REGION", "us-east-1")
    access_key = os.getenv("AWS_ACCESS_KEY_ID", "test")
    secret_key = os.getenv("AWS_SECRET_ACCESS_KEY", "test")

    return boto3.resource(
        "dynamodb",
        endpoint_url=endpoint,
        region_name=region,
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key,
    )


app = Flask(__name__)
table_name = os.getenv("TABLE_NAME", "terraform-training-items")
dynamodb = build_dynamodb_client()
table = dynamodb.Table(table_name)


@app.route("/")
def index():
    return jsonify(
        {
            "message": "Terraform + LocalStack demo API",
            "routes": ["/health", "/items"],
        }
    )


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


@app.route("/items", methods=["GET"])
def list_items():
    try:
        response = table.scan()
    except ClientError as exc:
        return jsonify({"error": str(exc)}), 500

    return jsonify(response.get("Items", []))


@app.route("/items", methods=["POST"])
def create_item():
    payload = request.get_json(force=True, silent=True) or {}
    item = {
        "pk": str(uuid.uuid4()),
        "name": payload.get("name", "anonymous"),
    }

    try:
        table.put_item(Item=item)
    except ClientError as exc:
        return jsonify({"error": str(exc)}), 500

    return item, 201


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
