
FROM rhub/r-minimal

# Need https://github.com/tidyverse/readxl/pull/687 for readxl

RUN installr -d \
    -t "curl-dev libxml2-dev linux-headers gfortran" \
    -a "libcurl libxml2"  \
    gaborcsardi/readxl@fix/alpine-linux tidyverse
