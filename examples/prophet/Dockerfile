
FROM rhub/r-minimal

# install depencies by hand
RUN apk add g++ linux-headers gfortran
RUN installr -t "linux-headers gfortran g++" StanHeaders ggplot2 inline gridExtra loo pkgbuild BH dygraphs extraDistr grid methods rstantools scales stats tidyr xts

# install a version of rstan which does not deal with V8
RUN Rscript -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rstan/rstan_2.19.3.tar.gz", type = "source")'

# install prophet
RUN Rscript -e 'install.packages("prophet", repos = "https://cloud.r-project.org/", dependencies = "Depends")'
