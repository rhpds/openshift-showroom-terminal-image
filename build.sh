#!/bin/bash
# -----------------------------------------------
# Build Showroom Terminal Base Image
# -----------------------------------------------
TTYD_VERSION="1.7.7"
TINI_VERSION="0.19.0"
BUILD_DATE=$(date +"%Y-%m-%d")
IMAGE_NAME=quay.io/rhpds/openshift-showroom-terminal-baseimage

podman build . --file Containerfile.base \
  --build-arg TTYD_VERSION=${TTYD_VERSION} \
  --build-arg TINI_VERSION=${TINI_VERSION} \
  --build-arg BUILD_DATE=${BUILD_DATE} \
  --tag ${IMAGE_NAME}:latest

if [ $? -ne 0 ]; then
  echo "*******************************************************************************"
  echo "Error building image ${IMAGE_NAME}."
  echo "*******************************************************************************"

  exit
fi

podman tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${BUILD_DATE}
podman push ${IMAGE_NAME}:latest
podman push ${IMAGE_NAME}:${BUILD_DATE}

# -------------------------------------------------------------------
# Build Showroom Terminal Image for OpenShift Environments
# -------------------------------------------------------------------
OCP_VERSION="4.19"
HELM_VERSION="latest"
ODO_VERSION="v3.16.1"
TKN_VERSION="latest"
KN_VERSION="latest"
VIRTCTL_VERSION="v1.5.2"
ROXCTL_VERSION="latest"
JAVA_VERSION=17
MAVEN_VERSION="3.9.11"

BUILD_DATE=$(date +"%Y-%m-%d")
IMAGE_NAME=quay.io/rhpds/openshift-showroom-terminal-ocp

podman build . --file Containerfile.ocp \
  --build-arg BUILD_DATE=${BUILD_DATE} \
  --build-arg JAVA_VERSION=${JAVA_VERSION} \
  --build-arg MAVEN_VERSION=${MAVEN_VERSION} \
  --build-arg OCP_VERSION=${OCP_VERSION} \
  --build-arg HELM_VERSION=${HELM_VERSION} \
  --build-arg ODO_VERSION=${ODO_VERSION} \
  --build-arg TKN_VERSION=${TKN_VERSION} \
  --build-arg KN_VERSION=${KN_VERSION} \
  --build-arg VIRTCTL_VERSION=${VIRTCTL_VERSION} \
  --build-arg ROXCTL_VERSION=${ROXCTL_VERSION} \
  --tag ${IMAGE_NAME}:latest

if [ $? -ne 0 ]; then
  echo "*******************************************************************************"
  echo "Error building image ${IMAGE_NAME}."
  echo "*******************************************************************************"

  exit
fi

podman tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${BUILD_DATE}
podman push ${IMAGE_NAME}:latest
podman push ${IMAGE_NAME}:${BUILD_DATE}

# -------------------------------------------------------------------
# Build Showroom Terminal Image for ROSA Environments
# -------------------------------------------------------------------
ROSA_VERSION=latest
BUILD_DATE=$(date +"%Y-%m-%d")
IMAGE_NAME=quay.io/rhpds/openshift-showroom-terminal-rosa

podman build . --file Containerfile.rosa \
  --build-arg BUILD_DATE=${BUILD_DATE} \
  --build-arg ROSA_VERSION=${ROSA_VERSION} \
  --tag ${IMAGE_NAME}:latest

if [ $? -ne 0 ]; then
  echo "*******************************************************************************"
  echo "Error building image ${IMAGE_NAME}."
  echo "*******************************************************************************"

  exit
fi

podman tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${BUILD_DATE}
podman push ${IMAGE_NAME}:latest
podman push ${IMAGE_NAME}:${BUILD_DATE}

# -------------------------------------------------------------------
# Build Showroom Terminal Image for ARO Environments
# -------------------------------------------------------------------
BUILD_DATE=$(date +"%Y-%m-%d")
IMAGE_NAME=quay.io/rhpds/openshift-showroom-terminal-aro

podman build . --file Containerfile.aro \
  --build-arg BUILD_DATE=${BUILD_DATE} \
  --build-arg ROSA_VERSION=${ROSA_VERSION} \
  --tag ${IMAGE_NAME}:latest

if [ $? -ne 0 ]; then
  echo "*******************************************************************************"
  echo "Error building image ${IMAGE_NAME}."
  echo "*******************************************************************************"

  exit
fi

podman tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${BUILD_DATE}
podman push ${IMAGE_NAME}:latest
podman push ${IMAGE_NAME}:${BUILD_DATE}
