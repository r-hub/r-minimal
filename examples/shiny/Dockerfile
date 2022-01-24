
FROM rhub/r-minimal

RUN apk add --no-cache --update-cache \
        --repository http://nl.alpinelinux.org/alpine/v3.11/main \
        autoconf=2.69-r2 \
        automake=1.16.1-r0 && \
    # repeat autoconf and automake (under `-t`)
    # to (auto)remove them after installation
    installr -d \
        -t "libsodium-dev curl-dev linux-headers autoconf automake" \
        -a libsodium \
        shiny
