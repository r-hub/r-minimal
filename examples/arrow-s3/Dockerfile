# arrow with S3 support
# We cannot use Alpine's libarrow for this, as it is built without
# S3 support.
# We also need to use an older arrow version.
# Plus need to build this on an older R devel version.
# See also https://github.com/r-hub/r-minimal/issues/84

FROM ghcr.io/r-hub/r-minimal/r-minimal:2024-03-19

ENV ARROW_S3=ON

RUN mkdir -p ~/.R && echo "LDFLAGS+=-fPIC" >> ~/.R/Makevars
RUN installr -d \
    -t "make cmake linux-headers openssl-dev curl-dev" \
    -a "openssl libcurl" arrow@15.0.1
RUN R -q -e 'library(arrow)'
RUN R -q -e 'stopifnot(isTRUE(arrow::arrow_info()$capabilities[["s3"]]))'
