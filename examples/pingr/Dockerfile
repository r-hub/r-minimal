
FROM rhub/r-minimal

RUN installr -d -t linux-headers pingr

CMD [ "R", "-q", "-e", "pingr::is_online() || stop('offline')" ]
