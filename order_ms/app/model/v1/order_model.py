from flask_restx import Namespace, fields


order_ns = Namespace(
    "order", description="Order endpoints", path="/order", strict_slashes=False
)

unauthorized_response_model = order_ns.model(
    "UnauthorizedResponseModel",
    {
        "message": fields.String(
            description="Unauthorized error message", example="Unauthorized"
        )
    },
)

bad_request_response_model = order_ns.model(
    "BadRequestResponseModel",
    {"message": fields.String(description="Bad request message")},
)

not_found_response_model = order_ns.model(
    "NotFoundResponseModel",
    {"message": fields.String(description="Not found error message")},
)


internal_server_error_response_model = order_ns.model(
    "InternalServerErrorResponseModel",
    {
        "message": fields.String(
            description="Internal server error message", example="Internal server error"
        )
    },
)

generic_request_model = order_ns.model(
    "GenericRequestModel",
    {
        "message": fields.String(required=True, description="Generic message"),
    },
)

generic_response_model = order_ns.model(
    "GenericResponseModel",
    {
        "message": fields.String(required=True, description="Generic message"),
    },
)
