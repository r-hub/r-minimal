
FROM rhub/r-minimal

RUN mkdir -p ~/.R && echo "LDFLAGS+=-fPIC" >> ~/.R/Makevars

RUN installr -d \
    -t "make openssl-dev cmake linux-headers apache-arrow-dev" \
    -a "openssl libarrow_dataset libarrow" arrow

RUN R -q -e 'library(arrow)'
