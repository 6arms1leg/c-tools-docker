# Software version pinning
FROM alpine:3.17
ARG PAYLOAD_VER=3.10.10-r0

# Version info.
ARG DOCKER_IMG_VER=0.1.0

# Main ("payload") software
ARG PAYLOAD=python

# Docker image labels
LABEL maintainer="sixarms1leg"
LABEL name="$PAYLOAD"
LABEL description="Execute arbitrary genral purpose scripts with Python"
LABEL version=$DOCKER_IMG_VER

# Version info. (visible at run time from within Docker container)
ENV DOCKER_IMG_VER $DOCKER_IMG_VER

# Install base/support software
RUN apk add --no-cache make

# Install main ("payload") software
RUN apk add --no-cache \
        bash \
        py3-numpy \
        py3-pandas \
        py3-pip \
        py3-setuptools \
        py3-wheel \
        python3=$PAYLOAD_VER
ENV PYTHONUNBUFFERED=1

# Switch to non-root user
RUN addgroup $PAYLOAD && \
    adduser -D -G $PAYLOAD $PAYLOAD
USER $PAYLOAD

# Install additional main ("payload") software (as non-root user)
ENV PATH "/home/$PAYLOAD/.local/bin/:$PATH"
RUN pip install --no-cache-dir --upgrade tabulate

# Set up working dir. and add to `$PATH` to ease project script exec.
WORKDIR /project/
ENV PATH "/project/:$PATH"

# Execute main ("payload") software by default
ENTRYPOINT ["/usr/bin/python"]
CMD ["--help"]
