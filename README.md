
# Minimal Docker images for R

## What is R?

R is a free software environment for statistical computing and graphics.
It compiles and runs on a wide variety of UNIX platforms, Windows and
MacOS. See more at https://www.r-project.org/

## Goals and features

The main goal of these images is to keep them minimal, so they can be used
as part of a bigger (web) application, or as a base image. Currently the
`r-minimal` image is less than 20MB compressed, and 32MB uncompressed.

All images use Alpine Linux.

The images include the `installr` tools that can install R packages from
CRAN or GitHub.

## Limitations

To keep the images minimal, they do not include a number of parts and
features that most users would prefer to have for interactive R
development:

* Recommended R packages are not installed.
* Documentation is not included.
* No readline library support.
* No X11 support.
* No Java support.
* No OpenMP support.
* No JPEG, PNG or TIFF support.
* No Cairo support.
* No Tcl/Tk support.
* No translations, only English.
* The image does not have C, C++ or Fortran compilers.

## Dockerfile examples

One of our main goals is to be able to use `rhub/r-minimal` as a base
image, and easily add R packages from CRAN or GitHub to it, to create a
new image. Run `installr` from a `Dockerfile` to add R packages to
the `r-minimal` image:

```
FROM rhub/r-minimal
RUN installr praise
CMD [ "R", "--slave", "-e", "cat(praise::praise())" ]
```

Package with compiled code:

```
FROM rhub/r-minimal
RUN installr -d glue
```

After the package(s) have been installed, `installr` removed the compilers,
as these are typically not needed on the final image. If you want to keep
them use `installr -c` instead of `installr -d`.

Package with system requirements:

```
FROM rhub/r-minimal
RUN installr -d -t linux-headers pingr
CMD [ "R", "-q", "-e", "pingr::is_online() || stop('offline')" ]
```

Similarly to compilers, system packages are removed after the R packages
have been installed. If you want to keep (some of) them, use `installr -a`
instead of `installr -t`. (You can also mix the two.)

## Popular packages:

Hints on installing some popular R packages:

package         | installr command                                          | ~ image size
--------------- | --------------------------------------------------------- | -------------
data.table      | `installr -d -t zlib-dev data.table`                      |  36.9 MB
dplyr           | `installr -d dplyr`                                       | 171.9 MB
ggplot2         | `installr -d -t gfortran ggplot2`                         | 123.4 MB
h2o             | `installr -d -a openjdk10-jre -t "curl-dev musl-dev" h2o` | 363.2 MB
knitr           | `installr -d knitr`                                       |  73.6 MB
prophet         | `installr -d -t "gfortran linux-headers" prophet`         | 389.7 MB
shiny           | `installr -d -t "file automake autoconf" shiny`           | 178.0 MB
rmarkdown       | `installr -d rmarkdown`                                   | 196.8 MB (including pandoc)

> Note that package and system dependencies change over time, so if any
> of these commands do not work any more, please
> [let us know](https://github.com/r-hub/r-minimal).

> See the [examples/rmarkdown/Dockerfile] for installing pandoc.

## Known failures

* The fs package does not build on Alpine Linux:
  https://github.com/r-lib/fs/issues/210
  So other packages depending on it do not work, either, e.g. devtools
  or mlflow.

* The xgboost package does not compile on Alpine Linux:
  https://github.com/dmlc/xgboost/issues/5131

## License

See https://www.r-project.org/Licenses/ for the R licenses

These Dockerfiles are licensed under the MIT License.

(c) [R Consortium](https://github.com/rconsortium)
