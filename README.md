
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
* No X11 support.
* No Java support.
* No OpenMP support.
* No JPEG, PNG or TIFF support.
* No Cairo support.
* No Tcl/Tk support.
* No translations, only English.
* The image does not have C, C++ or Fortran compilers.
* Limited time zone data: `GMT`, `UTC` and `America/New_York`, see
  below if you need better time zone data.

## Usage

Get the image from
[Docker Hub](https://hub.docker.com/repository/docker/rhub/r-minimal):

```
docker pull docker.io/rhub/r-minimal:latest
```

or from [GitHub Packages](https://github.com/r-hub/r-minimal/packages/92808?version=latest):

```
docker pull docker.pkg.github.com/r-hub/r-minimal/r-minimal:latest
```

## Supported R versions

Currently we support the last patch version of the last five minor R
versions. The `latest` tag always uses the last R release.

image  | tags   | note
------ | ------ | ----
[R development version](https://github.com/r-hub/r-minimal/packages/92808?version=devel)  | `devel` | Built daily
[R 4.1.0](https://github.com/r-hub/r-minimal/packages/92808?version=4.1.0)  | `4.1.0`, `4.1`, `latest` |
[R 4.0.5 patched](https://github.com/r-hub/r-minimal/packages/92808?version=patched)  | `4.0.5-patched`, `4.0-patched`, `patched` | Built daily
[R 4.0.5](https://github.com/r-hub/r-minimal/packages/92808?version=4.0.5)  | `4.0.5`, `4.0` |
[R 3.6.3](https://github.com/r-hub/r-minimal/packages/92808?version=3.6.3)  | `3.6.3`, `3.6` |
[R 3.5.3](https://github.com/r-hub/r-minimal/packages/92808?version=3.5.3)  | `3.5.3`, `3.5` |
[R 3.4.4](https://github.com/r-hub/r-minimal/packages/92808?version=3.4.4)  | `3.4.4`, `3.4` |
[R 3.3.3](https://github.com/r-hub/r-minimal/packages/92808?version=3.3.3)  | `3.3.3`, `3.3` |
[R 3.2.5](https://github.com/r-hub/r-minimal/packages/92808?version=3.2.5)  | `3.2.5`, `3.2` |

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
shiny           | `installr -d -t "file automake autoconf" shiny`           | 178.0 MB
rmarkdown       | `installr -d rmarkdown`                                   | 196.8 MB (including pandoc)

> Note that package and system dependencies change over time, so if any
> of these commands do not work any more, please
> [let us know](https://github.com/r-hub/r-minimal).

> See the [examples/rmarkdown/Dockerfile] for installing pandoc.

## Time zones

The image uses R's internal time zone database, but most time zones are
removed from, to save space. The only supported ones are `GMT`, `UTC` and
`America/New_York`. If you need more time zones, then install Alpine's
time zone package and point R to it:
```
apk add --no-cache tzdata
export TZDIR=/usr/share/zoneinfo
```

See also the discussion at https://github.com/r-hub/r-minimal/issues/24

## Known failures

* The current CRAN version (0.90.0.2) of the xgboost package does not
  compile on Alpine Linux. The development version on GitHub does,
  but `installr` cannot install that until Issue #4 is fixed. Some
  details:
  https://github.com/dmlc/xgboost/issues/5131

* The arrow package are hard to install, because Alpine Linux does 
  not have the required libraries. For the details, please see:
  - https://github.com/r-hub/r-minimal/issues/7 to install arrow

* The prophet package needs some special handling because it depends
  in V8, thorugh rstan, and the system libraries needed for V7 are
  hard to install on Alpine. See [examples/prophet/Dockerfile] for
  installing an older version of rstan, that does not need V8. See also the
  discussion at https://github.com/r-hub/r-minimal/issues/22

* The CRAN version of the odbc package does not compile on Alpine Linux.
  There is a fix at https://github.com/r-dbi/odbc/pull/400 which you
  can install from `gaborcsardi/odbc`. See the discussion at
  https://github.com/r-hub/r-minimal/issues/25

* The CRAN version (1.3.1) or the readxl package does not compile on
  Alpine Linux. You can install it from GitHub: `tidyverse/readxl`.
  For installing the tidyverse package, install `tidyverse/readxl` first,
  see the [examples/tidyverse/Dockerfile].

## License

See https://www.r-project.org/Licenses/ for the R licenses

These Dockerfiles are licensed under the MIT License.

(c) [R Consortium](https://github.com/rconsortium)
