#!/bin/bash
JAVA_VERSION=17
MAVEN_VERSION="3.9.6"
OCP_VERSION="4.14"
BUILD_DATE=$(date +"%Y-%m-%d")

podman build . \
  --build-arg JAVA_VERSION=${JAVA_VERSION} \
  --build-arg MAVEN_VERSION=${MAVEN_VERSION} \
  --build-arg OCP_VERSION=${OCP_VERSION} \
  --build-arg BUILD_DATE=${BUILD_DATE} \
  --tag quay.io/rhpds/showroom-terminal:latest

# podman tag quay.io/rhpds/showroom-terminal:latest quay.io/rhpds/showroom-terminal:${BUILD_DATE}
# podman push quay.io/rhpds/showroom-terminal:latest
# podman push quay.io/rhpds/showroom-terminal:${BUILD_DATE}