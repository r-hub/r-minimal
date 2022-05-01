
ARG ALPINE_VERSION=3.14.3

FROM alpine:${ALPINE_VERSION} as build

MAINTAINER "r-hub admin" admin@r-hub.io

ENV _R_SHLIB_STRIP_=true

ARG R_VERSION=4.1.3

WORKDIR /root

RUN apk update
RUN apk add gcc musl-dev gfortran g++ zlib-dev bzip2-dev xz-dev pcre-dev \
    pcre2-dev curl-dev make perl readline-dev

RUN if [[ "$R_VERSION" == "devel" ]]; then                                   \
        wget https://cran.r-project.org/src/base-prerelease/R-devel.tar.gz;  \
    elif [[ "$R_VERSION" == "next" ]]; then                                  \
        wget https://cran.rstudio.com/src/base-prerelease/R-latest.tar.gz -O R-next.tar.gz; \
    else                                                                     \
        wget https://cran.rstudio.com/src/base/R-${R_VERSION%%.*}/R-${R_VERSION}.tar.gz; \
    fi
RUN tar xzf R-${R_VERSION}.tar.gz

# The directory inside the tarball sometimes has different names

RUN if [[ -e R-patched ]]; then	mv R-patched R-next; fi
RUN if [[ -e R-beta ]]; then mv R-beta R-next; fi
RUN if [[ -e R-alpha ]]; then mv R-alpha R-next; fi
RUN if [[ -e R-rc ]]; then mv R-rc R-next; fi
RUN if [[ -e R-prerelease ]]; then mv R-prerelease R-next; fi
RUN if [[ -e R-pre ]]; then mv R-pre R-next; fi

RUN if echo ${R_VERSION} | grep -q "^3[.][45][.]"; then                        \
       echo "export CFLAGS='-D__MUSL__ -fcommon'" >> R-${R_VERSION}/FLAGS;     \
       echo "export FFLAGS=-fallow-argument-mismatch" >> R-${R_VERSION}/FLAGS; \
    else                                                                       \
       echo "export CFLAGS=-D__MUSL__" >> R-${R_VERSION}/FLAGS;                \
    fi

RUN cd R-${R_VERSION} &&                                                 \
    . FLAGS &&                                                           \
    CXXFLAGS=-D__MUSL__  ./configure                                     \
        --with-recommended-packages=no                                   \
        --with-readline=yes --with-x=no --enable-java=no                 \
        --enable-R-shlib                                                 \
        --disable-openmp --with-internal-tzcode
RUN cd R-${R_VERSION} && make -j 4
RUN cd R-${R_VERSION} && make install

RUN strip -x /usr/local/lib/R/bin/exec/R
RUN strip -x /usr/local/lib/R/lib/*
RUN find /usr/local/lib/R -name "*.so" -exec strip -x \{\} \;

RUN rm -rf /usr/local/lib/R/library/translations
RUN rm -rf /usr/local/lib/R/doc
RUN mkdir -p /usr/local/lib/R/doc/html
RUN find /usr/local/lib/R/library -name help | xargs rm -rf

RUN find /usr/local/lib/R/share/zoneinfo/America/ -mindepth 1 -maxdepth 1 \
    '!' -name New_York  -exec rm -r '{}' ';'
RUN find /usr/local/lib/R/share/zoneinfo/ -mindepth 1 -maxdepth 1 \
    '!' -name UTC '!' -name America '!' -name GMT -exec rm -r '{}' ';'

RUN sed -i 's/,//g' /usr/local/lib/R/library/utils/iconvlist

RUN touch /usr/local/lib/R/doc/html/R.css

# ----------------------------------------------------------------------------

FROM alpine:${ALPINE_VERSION} as final
ARG R_VERSION=4.1.3

ENV _R_SHLIB_STRIP_=true
ENV TZ=UTC

COPY --from=build /usr/local /usr/local

COPY installr /usr/local/bin/

RUN apk add --no-cache libgfortran xz-libs libcurl libpcrecpp libbz2      \
    pcre2 make readline

RUN apk add --no-cache bash && \
    ln -sf /bin/bash /bin/sh;

WORKDIR /root

ENV DOWNLOAD_STATIC_LIBV8=1

CMD ["R"]
