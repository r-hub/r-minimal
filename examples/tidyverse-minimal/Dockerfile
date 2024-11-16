FROM rhub/r-minimal AS build

RUN installr -d \
    -t "curl-dev libxml2-dev linux-headers gfortran fontconfig-dev fribidi-dev harfbuzz-dev freetype-dev libpng-dev tiff-dev" \
    -a "libcurl libxml2 fontconfig fribidi harfbuzz freetype libpng tiff libjpeg icu-libs" \
    tidyverse

RUN rm -rf /usr/local/lib/R/library/*/help && \
    rm -rf /usr/local/lib/R/library/*/NEWS* && \
    rm -rf /usr/local/lib/R/library/*/html && \
    rm -rf /usr/local/lib/R/library/*/doc && \
    rm -rf /usr/local/lib/R/library/data.table/tests && \
    rm -rf /usr/local/lib/R/library/knitr/examples && \
    rm -rf /usr/local/lib/R/library/lubridate/pkgdown && \
    rm -rf /usr/local/lib/R/library/googledrive/extdata && \
    rm -rf /usr/local/lib/R/library/colorspace/*/www && \
    rm -rf /usr/local/lib/R/library/vroom/bench

RUN cd /usr/local/lib/R/library && \
    rm -rf sass fontawesome tinytex reprex rmarkdown bslib callr processx ps \
           knitr jquerylib evaluate highr xfun yaml base64enc htmltools digest

FROM rhub/r-minimal

COPY --from=build /usr/local/lib/R/library /usr/local/lib/R/library
