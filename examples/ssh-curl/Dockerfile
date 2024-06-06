FROM rhub/r-minimal

RUN installr -c -p -a "openssl openssl-dev libssh2 libssh2-dev libpsl libpsl-dev perl" \
    && wget -qO - https://curl.haxx.se/download/curl-8.8.0.tar.gz \
    | tar xz \
    && cd curl-* \
    && ./configure --with-openssl --with-libssh2 \
    && make \
    && make install \
    && cd .. \
    && rm -rf curl-* \
    && installr -d -t "openssl-dev libssh2-dev libpsl-dev perl" curl
