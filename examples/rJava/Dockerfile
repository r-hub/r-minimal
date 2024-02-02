FROM rhub/r-minimal

RUN installr -c -p -a "openjdk17 pcre2 pcre2-dev libbz2 bzip2-dev xz-libs xz-dev" \
    && R CMD javareconf \
    && installr -d -t "pcre2-dev bzip2-dev xz-dev" rJava
