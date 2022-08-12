
FROM rhub/r-minimal as build

RUN apk add curl

RUN curl -LO https://artifacts.unidata.ucar.edu/repository/downloads-udunits/2.2.28/udunits-2.2.28.tar.gz

RUN tar xzf udunits-*

RUN installr -c -a "expat-dev"

RUN cd udunits-2.2.28 && \
    ./configure -prefix=/usr/local && \
    make && \
    make install

FROM rhub/r-minimal

COPY --from=build /usr/local /usr/local

RUN installr -d \
        -t "openssl-dev linux-headers gfortran proj-dev gdal-dev sqlite-dev geos-dev" \
	-a "libssl1.1 proj gdal geos expat" \
	sf

RUN R -q -e 'library(sf)'
