
FROM alpine:3.12.1 as build

MAINTAINER "r-hub admin" admin@r-hub.io

ENV _R_SHLIB_STRIP_=true

ARG R_VERSION=4.0.3

WORKDIR /root

RUN apk update
RUN apk add gcc musl-dev gfortran g++ zlib-dev bzip2-dev xz-dev pcre-dev \
    pcre2-dev curl-dev make perl readline-dev

RUN if [[ "$R_VERSION" == "devel" ]]; then                               \
        wget https://stat.ethz.ch/R/daily/R-devel.tar.gz;                \
    elif [[ "$R_VERSION" == "patched" ]]; then                           \
        wget https://stat.ethz.ch/R/daily/R-patched.tar.gz;              \
    else                                                                 \
        wget https://cran.r-project.org/src/base/R-${R_VERSION%%.*}/R-${R_VERSION}.tar.gz; \
    fi
RUN tar xzf R-${R_VERSION}.tar.gz

RUN cd R-${R_VERSION} &&                                                 \
    CXXFLAGS=-D__MUSL__ ./configure --with-recommended-packages=no       \
        --with-readline=yes --with-x=no --enable-java=no                 \
        --disable-openmp
RUN cd R-${R_VERSION} && make -j 4
RUN cd R-${R_VERSION} && make install

RUN strip -x /usr/local/lib/R/bin/exec/R
RUN strip -x /usr/local/lib/R/lib/*
RUN find /usr/local/lib/R -name "*.so" -exec strip -x \{\} \;

RUN rm -rf /usr/local/lib/R/library/translations
RUN rm -rf /usr/local/lib/R/doc
RUN mkdir -p /usr/local/lib/R/doc/html
RUN find /usr/local/lib/R/library -name help | xargs rm -rf

RUN touch /usr/local/lib/R/doc/html/R.css

# ----------------------------------------------------------------------------

FROM alpine:3.12.1

ENV _R_SHLIB_STRIP_=true

COPY --from=build /usr/local /usr/local

COPY remotes.R /usr/local/bin/
COPY installr /usr/local/bin/

RUN apk add --no-cache libgfortran xz-libs libcurl libpcrecpp libbz2      \
    pcre2 make readline

WORKDIR /root

CMD ["R"]
