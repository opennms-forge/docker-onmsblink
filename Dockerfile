FROM opennms/maven:3.3.9_8u121-jdk

MAINTAINER Ronny Trommer <ronny@opennms.org>

ARG ONMS_BLINK_VERSION=0.5
ARG ONMS_BLINK_URL=https://github.com/opennms-forge/onmsblink/releases/download/${ONMS_BLINK_VERSION}/onmsblink-${ONMS_BLINK_VERSION}.tar.gz
ENV ONMS_BLINK_HOME=/opt/onmsblink

RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y install libusb1-devel && \
    yum clean all && \
    cd /opt && curl -L ${ONMS_BLINK_URL} | tar xz

# HEALTHCHECK --interval=10s --timeout=3s CMD curl --fail -s -I http://localhost:8980/opennms/login.jsp | grep "HTTP/1.1 200 OK" || exit 1

LABEL license="GPLv3" \
      org.opennms.blink.version="${OPENNMS_VERSION}" \
      vendor="OpenNMS Community" \
      author="Christian Pape <christian@opennms.org>" \
      name="onmsblink"

WORKDIR /opt/onmsblink

ENTRYPOINT ["/usr/bin/java", "-Djava.library.path=blink1/libraries", "-cp", "blink1/libraries/blink1.jar:target/onmsblink-1.0-SNAPSHOT-jar-with-dependencies.jar", "org.opennms.onmsblink.OnmsBlink"]

CMD ["--help"]
