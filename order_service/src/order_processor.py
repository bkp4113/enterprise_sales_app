import logging
import os

logger = logging.getLogger(__name__)
logger.setLevel(os.environ.get('LOG_LEVEL', 'INFO'))


def lambda_handler(event, context):
    logger.info("Event : {}".format(event))
    logger.info("Context : {}".format(context))

    # TODO: Build logic to process the order
    # Look up order and inventory
    # if inventory avail. process the order and update the inventory
    # mark the order processed
    response = {"message": f"Order processed: {event["order_id"]}"}

    return {"statusCode": 200, "body": response}
