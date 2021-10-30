
FROM rhub/r-minimal

RUN apk add --no-cache --update-cache \
        --repository http://nl.alpinelinux.org/alpine/v3.11/main \
        autoconf=2.69-r2 \
        automake=1.16.1-r0 && \
    # repeat autoconf and automake (under `-t`)
    # to (auto)remove them after installation
    installr -d \
        -t "openssl-dev linux-headers autoconf automake zlib-dev" \
        -a "openssl chromium chromium-chromedriver" \
        pagedown

RUN wget https://github.com/jgm/pandoc/releases/download/2.13/pandoc-2.13-linux-amd64.tar.gz && \
    tar xzf pandoc-2.13-linux-amd64.tar.gz && \
    mv pandoc-2.13/bin/* /usr/local/bin/ && \
    rm -rf pandoc-2.13*

COPY pagedown.sh /usr/local/bin/pagedown.sh

RUN chmod +x /usr/local/bin/pagedown.sh
