#!/bin/bash
IMAGE_NAME=squid-frontend
IMAGE_VERSION=$1

# login ECR
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com

# docker build and tag
docker build -t ${IMAGE_NAME} .
docker tag ${IMAGE_NAME}:latest 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/${IMAGE_NAME}:latest
docker tag ${IMAGE_NAME}:latest 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/${IMAGE_NAME}:${IMAGE_VERSION}

# docker push
docker push 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/${IMAGE_NAME}:latest
docker push 565906264822.dkr.ecr.ap-northeast-2.amazonaws.com/${IMAGE_NAME}:${IMAGE_VERSION}
