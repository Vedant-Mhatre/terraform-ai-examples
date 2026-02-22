import json
import logging
import os
import urllib.parse

import boto3

s3 = boto3.client("s3")
OUTPUT_BUCKET = os.environ["OUTPUT_BUCKET"]
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):
    processed = []
    failures = []

    for record in event.get("Records", []):
        message_id = record.get("messageId")

        try:
            body = json.loads(record["body"])

            for s3_event in body.get("Records", []):
                source_bucket = s3_event["s3"]["bucket"]["name"]
                source_key = urllib.parse.unquote_plus(s3_event["s3"]["object"]["key"])

                payload = {
                    "source_bucket": source_bucket,
                    "source_key": source_key,
                    "ingested_at": s3_event.get("eventTime"),
                    "event_name": s3_event.get("eventName"),
                }

                target_key = f"processed/{source_key}.json"
                s3.put_object(
                    Bucket=OUTPUT_BUCKET,
                    Key=target_key,
                    Body=json.dumps(payload).encode("utf-8"),
                    ContentType="application/json",
                )

                processed.append(target_key)
        except (json.JSONDecodeError, KeyError, TypeError) as exc:
            logger.warning("Malformed message skipped id=%s error=%s", message_id, exc)
            if message_id:
                failures.append({"itemIdentifier": message_id})
        except Exception as exc:
            logger.exception("Processing failed id=%s error=%s", message_id, exc)
            if message_id:
                failures.append({"itemIdentifier": message_id})

    return {"processed": len(processed), "keys": processed, "batchItemFailures": failures}
