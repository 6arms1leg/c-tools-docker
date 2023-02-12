# Software version pinning
FROM alpine:3.17
ARG PAYLOAD_VER=2.9.1-r0

# Version info.
ARG DOCKER_IMG_VER=0.1.0

# Main ("payload") software
ARG PAYLOAD=cppcheck

# Docker image labels
LABEL maintainer="sixarms1leg"
LABEL name="$PAYLOAD"
LABEL description="Analyze code statically with Cppcheck"
LABEL version=$DOCKER_IMG_VER

# Version info. (visible at run time from within Docker container)
ENV DOCKER_IMG_VER $DOCKER_IMG_VER

# Install base/support software
RUN apk add --no-cache \
        bash \
        make \
        python3

# Install main ("payload") software and create wrapper to ease MISRA script exec.
RUN apk add --no-cache cppcheck=$PAYLOAD_VER && \
    mkdir -p /opt/ && \
    printf \
        '#!/bin/sh\npython /usr/share/cppcheck/addons/misra.py "$@"' \
        > /opt/cppcheck-misra.sh && \
    chmod +x /opt/cppcheck-misra.sh && \
    ln -s /opt/cppcheck-misra.sh /usr/local/bin/cppcheck-misra

# Switch to non-root user
RUN addgroup $PAYLOAD && \
    adduser -D -H -G $PAYLOAD $PAYLOAD
USER $PAYLOAD

# Set up working dir. and add to `$PATH` to ease project script exec.
WORKDIR /project/
ENV PATH "/project/:$PATH"

# Execute main ("payload") software by default
ENTRYPOINT ["/usr/bin/cppcheck"]
CMD ["--help"]
