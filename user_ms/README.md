# User Microservice

User microservice capable of processing customer orders asynchronously.

## AWS Services
- DynamoDB
- DynamoDB(Stream)
- Lambda
- IAM
- XRAY
- Cloudwatch
- Cognito

## Pre install requirements
- < Python3.12
  - `brew install python3`
- AWS CLI
    - `brew install aws-cli`
  - Additionally AWS cli needs to be configured see: https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-configure.html
- Docker
  - `brew install docker`

### Python Setup

- To build and run API locally create a virtual envrionment using venv or pyenv(Needs to be installed via brew and python shim needs to be configured).

- Install pythond envrionment depenecy first
```bash 
    python3 -m venv .venv
    source .venv/bin/activate
    pip3 install -r requirements.txt
```

### Running locally

- If you're using VS Code you can start the Flask API server locally by below VS Code config
```json
{
    "name": "Python Debugger: Flask Server",
    "type": "debugpy",
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
Swagger documentation is available locally at: `http://127.0.0.1:5000/order_docs`

### Application Health endpoint
- Ping: `http://127.0.0.1:5000/v1/health`

### Docker Build
- To build with docker
`docker build -f Dockerfile -t order_ms .`

## Branching & MR Flow

We have three protected branches as follows and corrosponds to the specific AWS environment.
    - development (Dev)
    - stage (Staging)
    - main (Prod)

- Features, Spikes and Minor Fixes must be checked out from `development` branch with following flow.
    - `git checkout development & git pull`
    - `git checkout -b <git_issue_branch>`
    - Commit you changes to the `git commit -m "<message>"` checked branch
    - Push your changes to the branch `git push`
    - If needed merge the develop or other relevant development branch in your branch
    - Create MR for the source branch targeted to `development`

- Hotfix should be checked out from `stage` or `main` with following flow.
    - `git checkout main & git pull`
    - `git checkout -b <git_issue_branch>`
    - Commit you changes to the `git commit -m "<message>"` checked branch
    - Push your changes to the branch `git push`
    - Create MR for the source branch targeted to `main`

For both the CICD will deploy the changes sets to the respective branch upon successful build.
