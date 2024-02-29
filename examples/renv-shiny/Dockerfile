FROM rhub/r-minimal:4.3.2

ARG TARGETARCH
ARG PANDOC_VERSION=3.1.12

RUN wget https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-${TARGETARCH}.tar.gz && \
    tar xzf pandoc-*-linux-${TARGETARCH}.tar.gz && \
    mv pandoc-*/bin/* /usr/local/bin/ && \
    rm -rf pandoc-*

COPY . .

RUN installr -d -e \
    -t "zlib-dev cairo-dev" \
    -a "cairo font-liberation"


EXPOSE 3838

CMD ["R", "-e", "shiny::runApp(host = '0.0.0.0', port = 3838)"]
