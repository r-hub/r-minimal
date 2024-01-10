FROM rhub/r-minimal

RUN installr -d \
    -t "curl-dev libxml2-dev linux-headers gfortran fontconfig-dev fribidi-dev harfbuzz-dev freetype-dev libpng-dev tiff-dev" \
    -a "libcurl libxml2 fontconfig fribidi harfbuzz freetype libpng tiff libjpeg icu-libs" \
    tidyverse
