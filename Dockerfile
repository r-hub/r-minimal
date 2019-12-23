
FROM alpine:3.10.3

ENV _R_SHLIB_STRIP_=true

RUN apk update &&                                                        \
    apk add gcc musl-dev gfortran g++ zlib-dev bzip2-dev xz-dev pcre-dev \
    curl-dev make perl &&                                                \
##
    wget https://cran.r-project.org/src/base/R-3/R-3.6.2.tar.gz &&       \
    tar xzf R-3.6.2.tar.gz &&                                            \
##
    cd R-3.6.2 &&                                                        \
    CXXFLAGS=-D__MUSL__ ./configure --with-recommended-packages=no       \
        --with-readline=no --with-x=no --enable-java=no                  \
        --disable-openmp &&                                              \
    make &&                                                              \
    make install &&                                                      \
##
    rm -rf /R-3.6.2* &&                                                  \
##
    strip -x /usr/local/lib/R/bin/exec/R &&                              \
    strip -x /usr/local/lib/R/lib/* &&                                   \
    find /usr/local/lib/R -name "*.so" -exec strip -x \{\} \; &&         \
##
    rm -rf /usr/local/lib/R/library/translations &&                      \
    rm -rf /usr/local/lib/R/doc &&                                       \
    mkdir -p /usr/local/lib/R/doc/html &&                                \
    find /usr/local/lib/R/library -name help | xargs rm -rf &&           \
##
    apk del gfortran gcc g++ musl-dev zlib-dev bzip2-dev xz-dev curl-dev \
        pcre-dev perl &&                                                 \
##
    apk add libgfortran xz-libs libcurl libpcrecpp libbz2 &&             \
    rm -rf /var/cache/apk/*

RUN touch /usr/local/lib/R/doc/html/R.css

COPY remotes.R /usr/local/bin/
COPY installr /usr/local/bin/

CMD ["R"]
