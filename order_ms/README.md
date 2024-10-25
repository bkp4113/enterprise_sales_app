# Order Microservice

The Order microservice processes customer orders asynchronously.

---

## AWS Services

- DynamoDB
- DynamoDB (Streams)
- Lambda
- IAM
- X-Ray
- CloudWatch
- Cognito

---

## Pre-Install Requirements

1. **Python < 3.12**  
   Install Python:
   ```bash
   brew install python3
   ```

2. **AWS CLI**  
   Install AWS CLI:
   ```bash
   brew install aws-cli
   ```
   Configure the AWS CLI: [AWS CLI Configuration Guide](https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-configure.html)

3. **Docker**  
   Install Docker:
   ```bash
   brew install docker
   ```

### Python Setup

- To build and run the API locally, create a virtual environment using `venv` or `pyenv`. (`pyenv` needs to be installed via `brew`, and Python shim must be configured.)

- Install environment dependencies:
   ```bash
   python3 -m venv .venv
   source .venv/bin/activate
   pip3 install -r requirements.txt
   ```

---

## Running Locally

For VS Code users, you can start the Flask API server locally with the following VS Code configuration:

```json
{
    "name": "Python Debugger: Flask Server",
    "type": "python",
    "request": "launch",
    "module": "flask",
    "cwd": "${workspaceFolder}/order_ms/app",
    "args": [
        "wsgi:app",
        "--reload"
    ],
    "jinja": true,
    "justMyCode": true
}
```

### Swagger Documentation

Access Swagger documentation locally at: `http://127.0.0.1:5000/order_docs`

### Application Health Endpoint

- **Ping**: `http://127.0.0.1:5000/v1/health`

### Docker Build

To build the Docker image:
```bash
docker build -f Dockerfile -t order_ms .
```

---

## Branching & Merge Request Flow

We have three protected branches corresponding to specific AWS environments:

- **development** (Dev)
- **stage** (Staging)
- **main** (Prod)

### Feature, Spike, and Minor Fixes Flow

1. Start from the `development` branch:
   ```bash
   git checkout development && git pull
   git checkout -b <git_issue_branch>
   ```

2. Commit your changes:
   ```bash
   git commit -m "<message>"
   ```

3. Push the changes:
   ```bash
   git push
   ```

4. Merge the `development` branch or other relevant branches as needed, then create a Merge Request (MR) with `development` as the target.

### Hotfix Flow

1. Start from `stage` or `main`:
   ```bash
   git checkout main && git pull
   git checkout -b <git_issue_branch>
   ```

2. Commit your changes:
   ```bash
   git commit -m "<message>"
   ```

3. Push the changes:
   ```bash
   git push
   ```

4. Create an MR with `main` as the target.

### CI/CD Deployment

The CI/CD pipeline deploys change sets to the respective branch upon a successful build.