FROM rhub/r-minimal:4.2.3-patched

COPY installr /usr/local/bin/

RUN wget https://github.com/jgm/pandoc/releases/download/2.13/pandoc-2.13-linux-amd64.tar.gz && \
    tar xzf pandoc-2.13-linux-amd64.tar.gz && \
    mv pandoc-2.13/bin/* /usr/local/bin/ && \
    rm -rf pandoc-2.13*

COPY . .

RUN installr -d -e \
        -t "curl-dev libxml2-dev linux-headers gfortran fontconfig-dev fribidi-dev harfbuzz-dev freetype-dev libpng-dev tiff-dev zlib-dev" \
        -a "libcurl libxml2 fontconfig fribidi harfbuzz freetype libpng tiff libjpeg icu-libs"


EXPOSE 3838

CMD ["R", "-e", "shiny::runApp(host = '0.0.0.0', port = 3838)"]