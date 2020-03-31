FROM python:3.7-slim as cloudmapper

LABEL Project="https://github.com/kbroughton/aws-labs"

EXPOSE 8000
WORKDIR /aws-labs
ENV AWS_DEFAULT_REGION=us-east-1 

RUN apt-get update -y
RUN apt-get install -y build-essential autoconf automake libtool python3.7-dev python3-tk jq awscli
RUN apt-get install -y bash

COPY . /aws-labs

RUN bash
