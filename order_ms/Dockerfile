FROM public.ecr.aws/lambda/python:3.12

RUN dnf -y install git
COPY requirements.txt ./
RUN python3.12 -m pip install wheel
RUN python3.12 -m pip install setuptools
RUN python3.12 -m pip install --upgrade build
RUN python3.12 -m pip install -r requirements.txt -t .

COPY app/ ./app

COPY service/ ./service/

COPY util/ ./util/

# CMD ["app.lambda_handler"]
# CMD ["authorizer.lambda_handler"]

FROM python:3.12.5-alpine3.20

RUN apk add --update python3 py3-pip build-base git

WORKDIR /

COPY requirements.txt ./
RUN pip3 install -r ./requirements.txt

COPY app ./app
COPY tests ./tests

ENV PYTHONPATH=/ \
    PYTHONUNBUFFERED=1

# 5678 for debugging
EXPOSE 80 5678

RUN pytest tests/test*.py

ENTRYPOINT ["gunicorn", "app.wsgi:app", "--host", "0.0.0.0", "--port", "80", "--workers", "4"]