FROM alpine:3.12 as builder

LABEL maintainer="Aleksey Maydokin <amaydokin@gmail.com>"

ENV BROTLI_VERSION 1.0.7

RUN apk add --no-cache --virtual .build-deps \
        bash \
        cmake \
        curl \
        gcc \
        make \
        musl-dev \
    && mkdir -p /usr/src \
    && curl -LSs https://github.com/google/brotli/archive/v$BROTLI_VERSION.tar.gz | tar xzf - -C /usr/src \
    && cd /usr/src/brotli-$BROTLI_VERSION \
    && ./configure-cmake --disable-debug && make -j$(getconf _NPROCESSORS_ONLN)


FROM busybox:musl

ENV BROTLI_VERSION 1.0.7

COPY --from=builder /usr/src/brotli-$BROTLI_VERSION/brotli /bin/brotli
