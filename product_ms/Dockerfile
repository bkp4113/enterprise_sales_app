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