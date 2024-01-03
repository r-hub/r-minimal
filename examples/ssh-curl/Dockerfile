FROM rhub/r-minimal

RUN installr -c -p

RUN apk add --no-cache openssl openssl-dev libssh2 libssh2-dev \
    && wget -qO - https://curl.haxx.se/download/curl-8.5.0.tar.gz \
    | tar xz \
    && cd curl-* \
    && ./configure --with-openssl --with-libssh2 \
    && make \
    && make install \
    && apk del openssl-dev libssh2-dev

RUN installr -d curl
