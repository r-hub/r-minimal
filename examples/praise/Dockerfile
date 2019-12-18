
FROM rhub/r-minimal

RUN installr praise

CMD [ "R", "--slave", "-e", "cat(praise::praise())" ]
