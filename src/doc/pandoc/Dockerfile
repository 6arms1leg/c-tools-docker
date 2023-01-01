# Software version pinning
FROM alpine:3.17
ARG PAYLOAD_VER=2.19.2-r0

# Version info.
ARG DOCKER_IMG_VER=0.1.0

# Main ("payload") software
ARG PAYLOAD=pandoc

# Docker image labels
LABEL maintainer="sixarms1leg"
LABEL name="$PAYLOAD"
LABEL description="Convert documentation markup formats with Pandoc"
LABEL version=$DOCKER_IMG_VER

# Version info. (visible at run time from within Docker container)
ENV DOCKER_IMG_VER $DOCKER_IMG_VER

# Install base/support software
RUN apk add --no-cache \
        fontconfig \
        make \
        ncurses-libs \
        openjdk17-jre \
        perl \
        perl-digest-md5 \
        perl-getopt-long \
        py3-pygments \
        python3 \
        texlive-full

# Install main ("payload") software
RUN apk add --no-cache pandoc=$PAYLOAD_VER

# Switch to non-root user
RUN addgroup $PAYLOAD && \
    adduser -D -H -G $PAYLOAD $PAYLOAD
USER $PAYLOAD

# Set up working dir. and add to `$PATH` to ease project script exec.
WORKDIR /project/
ENV PATH "/project/:$PATH"

# Execute main ("payload") software by default
ENTRYPOINT ["/usr/bin/pandoc"]
CMD ["--help"]
