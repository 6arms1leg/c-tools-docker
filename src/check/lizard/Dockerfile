# Software version pinning
FROM alpine:3.17
ARG PAYLOAD_VER=1.17.10

# Version info.
ARG DOCKER_IMG_VER=0.1.0

# Main ("payload") software
ARG PAYLOAD=lizard

# Docker image labels
LABEL maintainer="sixarms1leg"
LABEL name="$PAYLOAD"
LABEL description="Analyze code complexity with Lizard"
LABEL version=$DOCKER_IMG_VER

# Version info. (visible at run time from within Docker container)
ENV DOCKER_IMG_VER $DOCKER_IMG_VER

# Install base/support software
RUN apk add --no-cache \
        bash \
        curl \
        make \
        py3-setuptools \
        python3

# Install main ("payload") software
RUN mkdir -p /build/ && \
    curl -L https://github.com/terryyin/lizard/archive/refs/tags/$PAYLOAD_VER.tar.gz | \
        tar xvz --strip-components=1 -C /build/ && \
    cd /build/ && \
    python ./setup.py install && \
    cd / && \
    rm -rf /build/

# Switch to non-root user
RUN addgroup $PAYLOAD && \
    adduser -D -H -G $PAYLOAD $PAYLOAD
USER $PAYLOAD

# Set up working dir. and add to `$PATH` to ease project script exec.
WORKDIR /project/
ENV PATH "/project/:$PATH"

# Execute main ("payload") software by default
ENTRYPOINT ["/usr/bin/lizard"]
CMD ["--help"]
