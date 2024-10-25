from flask_restx import Namespace


health_ns = Namespace(
    "health", description="Health endpoint", path="/health", strict_slashes=False
)
