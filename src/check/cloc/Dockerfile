# Software version pinning
FROM alpine:3.17
ARG PAYLOAD_VER=1.94-r0

# Version info.
ARG DOCKER_IMG_VER=0.1.0

# Main ("payload") software
ARG PAYLOAD=cloc

# Docker image labels
LABEL maintainer="sixarms1leg"
LABEL name="$PAYLOAD"
LABEL description="Count lines of code with CLOC"
LABEL version=$DOCKER_IMG_VER

# Version info. (visible at run time from within Docker container)
ENV DOCKER_IMG_VER $DOCKER_IMG_VER

# Install base/support software
RUN apk add --no-cache \
        bash \
        make \
        python3

# Install main ("payload") software
RUN apk add --no-cache cloc=$PAYLOAD_VER

# Install script to process CLOC output for ease-of-use in continuous integration
COPY ./chk-cloc-cmnt-rate.py /opt/
RUN chmod +x /opt/chk-cloc-cmnt-rate.py && \
    ln -s /opt/chk-cloc-cmnt-rate.py /usr/local/bin/chk-cloc-cmnt-rate

# Switch to non-root user
RUN addgroup $PAYLOAD && \
    adduser -D -H -G $PAYLOAD $PAYLOAD
USER $PAYLOAD

# Set up working dir. and add to `$PATH` to ease project script exec.
WORKDIR /project/
ENV PATH "/project/:$PATH"

# Execute main ("payload") software by default
ENTRYPOINT ["/usr/bin/cloc"]
CMD ["--help"]
