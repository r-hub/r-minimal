
FROM rhub/r-minimal

# install depencies by hand
# then install a version of rstan which does not deal with V8
# then install prophet
RUN apk add --no-cache linux-headers gfortran g++ curl-dev &&               \
    installr StanHeaders ggplot2 inline gridExtra loo pkgbuild BH           \
    dygraphs extraDistr grid methods rstantools scales stats tidyr xts &&   \
    Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.19.3.tar.gz", type = "source")' && \
    Rscript -e 'install.packages("prophet", repos = "https://cloud.r-project.org")' && \
    apk del linux-headers gfortran g++ curl-dev 
