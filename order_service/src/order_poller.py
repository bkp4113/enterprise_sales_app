import logging
import os

logger = logging.getLogger(__name__)
logger.setLevel(os.environ.get("LOG_LEVEL", "INFO"))


def lambda_handler(event, context):
    logger.info("Event : {}".format(event))
    logger.info("Context : {}".format(context))

    processed_orders = []
    for record in event["Records"]:
        logger.info(
            f'Stream eventId: {record.get('eventID')}, eventName: {record.get('eventName')}'
        )
        dynamodb_record = record.get("dynamodb").get("NewImage")
        processed_orders.append(dynamodb_record.get("order_id", {}).get("S", ""))

        # TODO: Invoke the order_processor func.

    response = {"message": f"Order batch processed: {event}"}

    return {"statusCode": 200, "body": response}
