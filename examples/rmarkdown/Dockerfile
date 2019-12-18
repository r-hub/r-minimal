
FROM rhub/r-minimal

RUN installr -d rmarkdown

RUN wget https://github.com/jgm/pandoc/releases/download/2.9/pandoc-2.9-linux-amd64.tar.gz && \
    tar xzf pandoc-2.9-linux-amd64.tar.gz && \
    mv pandoc-2.9/bin/* /usr/local/bin/ && \
    rm -rf pandoc-2.9*
