import os
import unittest
from unittest.mock import patch

from app.www.www_launcher import create_app


class TestHealthAPIModels(unittest.TestCase):
    def setUp(self):
        self.env_patcher = patch.dict(
            os.environ,
            {
                "AWS_ACCESS_KEY_ID": "dummy_access_key",
                "AWS_SECRET_ACCESS_KEY": "dummy_secret_key",
                "AWS_SESSION_TOKEN": "dummy_session_token",
                "AWS_DEFAULT_REGION": "us-east-2",
                "AWS_REGION": "us-east-2",
                "ENVIRONMENT": "test",
            },
        )

        self.env_patcher.start()

        self.app = create_app().test_client()

    def teardown(self):
        pass

    def test_get_health_200(self):
        response = self.app.get("/v1/health/")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.get_json(), {"status": "OK"})
