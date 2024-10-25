FROM public.ecr.aws/lambda/python:3.12

COPY requirements.txt ./
RUN python3.12 -m pip install wheel
RUN python3.12 -m pip install setuptools
RUN python3.12 -m pip install --upgrade build
RUN python3.12 -m pip install -r requirements.txt -t .

COPY src/ ./

# CMD ["order_poller.lambda_handler"]
# CMD ["order_processor.lambda_handler"]