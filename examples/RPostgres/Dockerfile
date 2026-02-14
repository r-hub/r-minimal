FROM rhub/r-minimal

# Temporarily need dev version of RPostgres, for this fix:
# https://github.com/r-dbi/RPostgres/commit/12053beb8a73e2bdaad0a63e8af0945c7f2e4812
RUN installr -d -t "libpq-dev" -a "libpq" r-dbi/RPostgres@4d9b628
