FROM rhub/r-minimal

RUN installr -c -p -a openjdk17 \
    && R CMD javareconf \
    && installr -d \
    -t "make pcre2-dev bzip2-dev xz-dev zstd-dev" \
    -a "pcre2 libbz2 xz-libs zstd" rJava
