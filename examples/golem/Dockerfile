
FROM rhub/r-minimal

# we have to install `shiny` first, to be able to install `golem`
# so I leave the example of `shiny` installation here
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

# installation of `golem`
RUN installr -d \
    -t "curl-dev openssl-dev libxml2-dev gfortran libgit2-dev" \
    -a "libgit2" golem
