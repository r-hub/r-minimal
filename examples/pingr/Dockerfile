
FROM rhub/r-minimal

RUN installr -d -t linux-headers r-lib/pingr

CMD [ "R", "-q", "-e", "pingr::is_online() || stop('offline')" ]
