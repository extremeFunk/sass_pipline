FROM python:2.7-alpine
COPY test /test
WORKDIR /test
RUN pip install -r requirments.txt
CMD python e2e_test.py