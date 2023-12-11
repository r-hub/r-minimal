
FROM rhub/r-minimal

RUN apk add udunits-dev --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community

RUN installr -d \
        -t "openssl-dev linux-headers gfortran proj-dev gdal-dev sqlite-dev geos-dev udunits-dev" \
	-a "libssl1.1 proj gdal geos expat udunits" \
	sf

RUN R -q -e 'library(sf)'
