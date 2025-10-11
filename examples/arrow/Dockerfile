
FROM rhub/r-minimal

RUN mkdir -p ~/.R && echo "LDFLAGS+=-fPIC" >> ~/.R/Makevars

# Alpine 3.22 (base of rhub/r-minimal) has arrow 19.x, so that's
# what we install, also.

RUN installr -d \
    -t "make openssl-dev cmake linux-headers apache-arrow-dev" \
    -a "openssl libarrow_dataset libarrow" arrow@19.0.1.1

RUN R -q -e 'library(arrow)'
