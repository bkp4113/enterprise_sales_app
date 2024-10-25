import logging
import os
import sys
import time

from flask import Blueprint, Flask, g, request
from flask_cors import CORS
from flask_restx import Api


from app.api.health import health_ns
from app.api.v1.order import order_ns as order_ns_v1

from app import config

logger = logging.getLogger(__name__)
logger.setLevel(os.getenv("LOG_LEVEL", "INFO"))
logger.info(f'LOG_LEVEL: {os.environ.get('LOG_LEVEL')}')

authorizations = {"Bearer": {"type": "apiKey", "in": "header", "name": "Authorization"}}

__name__ = "order_ms_app"


def create_app() -> Flask:
    """
    create_app Configure flask app

    :return Flask: flask app instance
    """
    logger.info("Setting up app")
    app = Flask(__name__)

    # Create a blueprint for API version 1
    api_v1 = Blueprint(
        "api_v1",
        __name__,
        url_prefix="/v1",
    )  # Ensure the prefix is correct

    # Attach Api to the blueprint
    api = Api(
        api_v1,
        version="1.0",
        title="Order Processing Enterprise APIs",
        description="Order Processing Enterprise REST APIs",
        authorizations=authorizations,
        security="Bearer",
        doc="/order_docs" if not config.disable_swagger else False,
    )

    # Register namespaces to the Api
    api.add_namespace(health_ns, path="/health")
    api.add_namespace(order_ns_v1, path="/order")

    # Register the blueprint to the app
    app.register_blueprint(api_v1)

    app.config["RESTX_VALIDATE"] = True
    app.config["RESTX_MASK_SWAGGER"] = False
    logger.info("Setup app")

    if not config.disable_swagger:

        @app.route("/order_docs")
        def swagger_ui():
            return api.render_doc()

    return app


logger.info("Initializing app")
app = create_app()

CORS(
    app,
    origins=config.cors_allowed_origin.split(","),
    supports_credentials=True,
    methods=config.cors_allowed_methods.split(","),
    allow_headers=config.cors_allowed_headers.split(","),
)
logger.info("Initialized app")


@app.before_request
def log_request_info():
    g.start_time = time.time()  # Start the request timer
    logger.debug(f"Request Path: {request.path}")
    logger.debug(f"Request Method: {request.method}")
    logger.debug(f"Request Headers: {request.headers}")
    if request.data and not request.path.startswith("/swaggerui"):
        logger.debug(f"Request Body: {request.get_data()}")


@app.after_request
def log_response_info(response):
    duration = time.time() - g.start_time  # Calculate how long the request took
    logger.debug(f"Response Status: {response.status}")
    logger.info(f"Duration: {duration:.4f} seconds")
    return response
