# Software version pinning
FROM alpine:3.15.6
ARG PAYLOAD_VER=0.31.1
ARG RUBY_VER=3.0.5-r0
ARG RUBYGEM_VER=3.0.0

# Version info.
ARG DOCKER_IMG_VER=0.1.0

# Main ("payload") software
ARG PAYLOAD=ceedling

# Docker image labels
LABEL maintainer="sixarms1leg"
LABEL name="$PAYLOAD"
LABEL description="Unit test C programs with Ceedling/Unity/CMock/CExeption"
LABEL version=$DOCKER_IMG_VER

# Version info. (visible at run time from within Docker container)
ENV DOCKER_IMG_VER $DOCKER_IMG_VER

# Install base/support software
RUN apk add --no-cache \
        bash \
        gcc \
        gcovr \
        libc-dev \
        make \
        ruby=$RUBY_VER

# Install main ("payload") software and apply patch for Unity bug
# (github.com/ThrowTheSwitch/Unity/pull/600)
RUN gem install ceedling -v $PAYLOAD_VER && \
    sed -i \
        's/CEXCEPTION_T e;/volatile CEXCEPTION_T e;/' \
        /usr/lib/ruby/gems/$RUBYGEM_VER/gems/ceedling-$PAYLOAD_VER/vendor/unity/auto/run_test.erb

# Switch to non-root user
RUN addgroup $PAYLOAD && \
    adduser -D -H -G $PAYLOAD $PAYLOAD
USER $PAYLOAD

# Set up working dir. and add to `$PATH` to ease project script exec.
WORKDIR /project/
ENV PATH "/project/:$PATH"

# Execute main ("payload") software by default
ENTRYPOINT ["/usr/bin/ceedling"]
CMD ["help"]
