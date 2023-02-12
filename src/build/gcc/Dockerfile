# Software version pinning
FROM alpine:3.17
ARG PAYLOAD_VER=12.2.1_git20220924-r4

# Version info.
ARG DOCKER_IMG_VER=0.1.0

# Main ("payload") software
ARG PAYLOAD=gcc

# Docker image labels
LABEL maintainer="sixarms1leg"
LABEL name="$PAYLOAD"
LABEL description="Compile C language code with GCC"
LABEL version=$DOCKER_IMG_VER

# Version info. (visible at run time from within Docker container)
ENV DOCKER_IMG_VER $DOCKER_IMG_VER

# Install base/support software
RUN apk add --no-cache \
        bash \
        libc-dev \
        make

# Install main ("payload") software
RUN apk add --no-cache gcc=$PAYLOAD_VER

# Switch to non-root user
RUN addgroup $PAYLOAD && \
    adduser -D -H -G $PAYLOAD $PAYLOAD
USER $PAYLOAD

# Set up working dir. and add to `$PATH` to ease project script exec.
WORKDIR /project/
ENV PATH "/project/:$PATH"

# Execute main ("payload") software by default
ENTRYPOINT ["/usr/bin/gcc"]
CMD ["--help"]
