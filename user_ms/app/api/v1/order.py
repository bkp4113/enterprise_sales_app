import logging
import os
import uuid

from app.model.v1.order_model import (
    bad_request_response_model,
    generic_request_model,
    generic_response_model,
    internal_server_error_response_model,
    order_ns,
    unauthorized_response_model,
)
from flask_restx import Resource, marshal

logger = logging.getLogger(__name__)
logger.setLevel(os.getenv("LOG_LEVEL", "INFO"))
logger.info(f'LOG_LEVEL: {os.environ.get('LOG_LEVEL')}')


@order_ns.route("/")
class CreateUserOrder(Resource):
    # Disabled otherwise would require "Authorization" api headers
    # @order_ns.doc(
    #     params={
    #         "Authorization": {
    #             "description": "Bearer Token",
    #             "in": "header",
    #             "type": "string",
    #             "required": True,
    #         }
    #     }
    # )
    # @order_ns.doc(security="Bearer")
    @order_ns.expect(generic_request_model)
    @order_ns.response(
        200,
        model=generic_response_model,
        description="Order Model",
    )
    @order_ns.response(400, "Bad request response.", bad_request_response_model)
    @order_ns.response(401, "Unauthorized error response.", unauthorized_response_model)
    @order_ns.response(
        500, "Internal server Error.", internal_server_error_response_model
    )
    # Decorator to authenticate user with auth token and validate scope and role
    # @get_claims
    # def post(self, auth):
    def post(self):
        """
        Create user order
        """
        logger.info("Creating order for user")

        # Create order in Dynamodb

        # if not authorized: return 401
        # if payload validation issues: return 400
        # if AWS or Unhandled application issue: return 500
        # else process order in DynamoDB with new order_id

        order_id = uuid.uuid4().__str__()
        order = {"message": f"Processed order:{order_id}"}
        logger.info(f"Processed order: {order_id}")

        return marshal(order, generic_response_model), 200
