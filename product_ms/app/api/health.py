import logging
import os

from flask import jsonify
from flask_restx import Resource

from app.model.health import (
    health_ns
)


logger = logging.getLogger(__name__)
logger.setLevel(os.getenv("LOG_LEVEL", "INFO"))
logger.info(f'LOG_LEVEL: {os.environ.get('LOG_LEVEL')}')


@health_ns.route("/")
class Health(Resource):
    def get(self):
        """
        Get health
        """
        logger.info("Health api pinged")

        return jsonify({"status": "OK"})