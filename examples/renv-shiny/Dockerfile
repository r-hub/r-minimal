FROM rhub/r-minimal:4.3.2


RUN wget https://github.com/jgm/pandoc/releases/download/3.1.12/pandoc-3.1.12-linux-amd64.tar.gz && \
    tar xzf pandoc-3.1.12-linux-amd64.tar.gz && \
    mv pandoc-3.1.12/bin/* /usr/local/bin/ && \
    rm -rf pandoc-3.1.12*

COPY . .

RUN installr -d -e \
        -t "zlib-dev"


EXPOSE 3838

CMD ["R", "-e", "shiny::runApp(host = '0.0.0.0', port = 3838)"]