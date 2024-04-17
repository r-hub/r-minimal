
FROM ghcr.io/r-hub/r-minimal/r-minimal

RUN echo -e 'PKG_CFLAGS+=-fopenmp\nPKG_LIBS+=-fopenmp\n' >> /tmp/Makevars && \
    R_MAKEVARS_USER=/tmp/Makevars \
    installr -a "libgomp zlib" -t "openmp-dev zlib-dev" -d data.table && \
    rm /tmp/Makevars

RUN R -q -e 'data.table::getDTthreads()'

RUN ldd /usr/local/lib/R/library/data.table/libs/data_table.so 2> /dev/null || true
