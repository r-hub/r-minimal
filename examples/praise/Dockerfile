
FROM rhub/r-minimal

RUN installr -d praise

CMD [ "R", "--slave", "-e", "cat(praise::praise())" ]
