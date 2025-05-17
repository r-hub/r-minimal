
FROM rhub/r-minimal

RUN installr -d \
        -t "openssl-dev cmake linux-headers gfortran proj-dev gdal-dev sqlite-dev geos-dev udunits-dev" \
	-a "libssl3 proj gdal geos expat udunits" \
	sf Rcppcore/Rcpp

RUN R -q -e 'library(sf)'
