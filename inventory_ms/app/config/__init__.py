import json
from os import environ
from dotenv import load_dotenv


# Load environment variables from dev.env
load_dotenv("dev.env")


# Initialize app configuration
class Config(object):
    def __init__(self) -> None:
        self.environment = environ.get("ENVIRONMENT", "test")
        self.disable_swagger = json.loads(environ.get("DISABLE_SWAGGER", "false"))
        self.cors_allowed_origin = environ.get("CORS_ALLOWED_ORIGIN", "*")
        self.cors_allowed_headers = environ.get("CORS_ALLOWED_HEADERS", "*")
        self.cors_allowed_methods = environ.get("CORS_ALLOWED_METHODS", "*")
