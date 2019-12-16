
FROM alpine:3.10.3

RUN apk update &&                                                        \
    apk add gcc musl-dev gfortran g++ zlib-dev bzip2-dev xz-dev pcre-dev \
    curl-dev make perl && 

RUN wget https://cran.r-project.org/src/base/R-3/R-3.6.2.tar.gz && \
    tar xzf R-3.6.2.tar.gz

RUN cd R-3.6.2 &&                                                  \
    ./configure --with-recommended-packages=no --with-readline=no  \
        --with-x=no --enable-java=no --disable-openmp &&           \
    make &&                                                        \
    make install

RUN rm -rf R-3.6.2*

RUN strip -x /usr/local/lib/R/bin/exec/R &&                        \
    strip -x /usr/local/lib/R/lib/* &&                             \
    find /usr/local/lib/R -name "*.so" -exec strip -x \{\} \;

RUN rm -rf /usr/local/lib/R/library/translations &&                \
    rm -rf /usr/local/lib/R/doc &&                                 \
    find /usr/local/lib/R/library -type d -name help -exec rm -rf \{\} \;

RUN apk del gfortran gcc g++ musl-dev zlib-dev bzip2-dev xz-dev curl-dev \
        pcre-dev perl

RUN apk add libgfortran xz-libs libcurl libpcrecpp libbz2
