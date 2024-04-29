
FROM rhub/r-minimal

RUN mkdir -p ~/.R && echo "LDFLAGS+=-fPIC" >> ~/.R/Makevars

# The most recent 15.0.1 version of the arrow package does not compile
# on Alpine, so we install the previous version. If you had success with
# newer versions, please let us know! Thanks!

RUN installr -d \
    -t "make openssl-dev cmake linux-headers apache-arrow-dev" \
    -a "openssl libarrow_dataset libarrow" arrow@14.0.2.1

RUN R -q -e 'library(arrow)'
