FROM docker.io/tsl0922/ttyd:latest as TTYD
# /usr/bin/tini
# /usr/bin/ttyd

FROM registry.access.redhat.com/ubi9:latest as TERMINAL

ARG MAVEN_VERSION="3.9.6"
ARG OCP_VERSION="4.14"
ARG JAVA_VERSION="17"
ARG BUILD_DATE="2023-10-01"

LABEL maintainer="Wolfgang Kulhanek - WolfgangKulhanek@gmail.com" \
      build-date=$BUILD_DATE

USER root

COPY --from=TTYD /usr/bin/tini /usr/bin/tini
COPY --from=TTYD /usr/bin/ttyd /usr/bin/ttyd

RUN dnf -y update && dnf -y upgrade && \
    dnf -y install wget && \
    dnf -y install java-${JAVA_VERSION}-openjdk java-${JAVA_VERSION}-openjdk-devel pinentry tzdata-java && \
    dnf clean all && \
    rm -rf /var/cache/yum /root/.cache

# Install Maven
RUN wget -O /tmp/maven.tar.gz https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir -p /usr/local/maven && tar -C /usr/local/maven --strip-components=1 -xzvf /tmp/maven.tar.gz && \
    ln -s /usr/local/maven/bin/mvn /usr/local/bin/mvn && \
    rm /tmp/maven.tar.gz

# Install OC CLI
RUN wget -O /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/ocp/stable-${OCP_VERSION}/openshift-client-linux.tar.gz && \
    tar -C /usr/local/bin -zxvf /tmp/oc.tar.gz && \
    rm /tmp/oc.tar.gz /usr/local/bin/README.md

RUN adduser lab-user --home-dir=/home/lab-user && \
    chmod 770 /home/lab-user && \
    chgrp 0 /home/lab-user && \
    chmod -R g=u /home/lab-user /etc/passwd

RUN chown root:root /usr/bin/tini /usr/bin/ttyd
RUN chmod o=rwx,g=rwx,o=rx /usr/bin/tini /usr/bin/ttyd
RUN dnf -y install vim

USER lab-user
WORKDIR /home/lab-user

EXPOSE 7681

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["ttyd", "-W", "bash"]