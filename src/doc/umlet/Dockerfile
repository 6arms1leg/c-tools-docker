# Software version pinning
FROM alpine:3.17
ARG PAYLOAD_VER=15.0.0

# Version info.
ARG DOCKER_IMG_VER=0.1.0

# Main ("payload") software
ARG PAYLOAD=umlet

# Docker image labels
LABEL maintainer="sixarms1leg"
LABEL name="$PAYLOAD"
LABEL description="Convert UMLet UML diagrams into common digital image formats"
LABEL version=$DOCKER_IMG_VER

# Version info. (visible at run time from within Docker container)
ENV DOCKER_IMG_VER $DOCKER_IMG_VER

# Install base/support software
RUN apk add --no-cache \
        curl \
        font-freefont \
        fontconfig \
        make \
        openjdk17-jre \
        unzip

# Install main ("payload") software and create wrapper to ease conversion
RUN mkdir -p /opt/ && \
    curl -L https://www.umlet.com/download/umlet_15_0/umlet-standalone-$PAYLOAD_VER.zip \
         -o /opt/umlet.zip && \
    unzip -q /opt/umlet.zip -d /opt/ && \
    mv /opt/Umlet/ /opt/umlet/ && \
    chmod +x /opt/umlet/umlet.sh && \
    ln -s /opt/umlet/umlet.sh /usr/local/bin/umlet && \
    rm -rf \
        /opt/umlet.zip \
        /opt/umlet/Umlet.exe && \
    printf \
        '#!/bin/sh\nARG1="$1"\nshift\numlet -action=convert -format="$ARG1" -filename="$@" 2>&1 | grep -v "log4j:WARN"' \
        > /opt/umlet-conv.sh && \
    chmod +x /opt/umlet-conv.sh && \
    ln -s /opt/umlet-conv.sh /usr/local/bin/umlet-conv
ENV UMLET_HOME="/opt/umlet/"

# Switch to non-root user
RUN addgroup $PAYLOAD && \
    adduser -D -G $PAYLOAD $PAYLOAD
USER $PAYLOAD

# Configure fonts used by UMLet
COPY ./fonts.conf /home/$PAYLOAD/.fonts.conf

# Set up working dir. and add to `$PATH` to ease project script exec.
WORKDIR /project/
ENV PATH "/project/:$PATH"

# Execute main ("payload") software by default
ENTRYPOINT ["/usr/local/bin/umlet-conv"]
CMD ["png", "./*.uxf"]
