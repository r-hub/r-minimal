
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Minimal Docker images for R

## What is R?

R is a free software environment for statistical computing and graphics.
It compiles and runs on a wide variety of UNIX platforms, Windows and
MacOS. See more at <https://www.r-project.org/>

## Goals and features

The main goal of these images is to keep them minimal, so they can be
used as part of a bigger (web) application, or as a base image.
Currently the (R 4.1.0) `r-minimal` image is less than 21MB compressed,
and 35.4MB uncompressed.

All images use Alpine Linux.

The images include the `installr` tools that can install R packages from
CRAN or GitHub:

    ❯ installr -h
    Usage: ./installr [ -c | -d ] [ -a pkgs ] [ -t pkgs ] [ -r ] [ -p ] REMOTES ...
    
    Options:
      -c    install C and C++ compilers and keep them
      -d    install C and C++ compilers, temporarily
      -a    install Alpine packages and keep them
      -t    install Alpine packages, temporarily
      -p    do not remove pak after the installation (ignored if -r is given).
    
    REMOTES may be:
      * package names from CRAN/Bioconductor, e.g.    ggplot2
      * slugs of GitHub repos, e.g.                   tidyverse/ggplot2
      * GitHub branch, tag or commit, e.g             tidyverse/ggplot2@v1.0.0
      * URLs to package .tar.gz files, e.g.           url::https://x.com/pkg.tar.gz
      * path to a local directory, e.g.               local::.

Recent r-minimal containers use pak (<https://github.com/r-lib/pak>) for
R packages installation. If you have problems with pak, or need to
install a package from a source that pak does not support, but the
remotes package does, then install the remotes package first.

## Limitations

To keep the images minimal, they do not include a number of parts and
features that most users would prefer to have for interactive R
development:

  - Recommended R packages are not installed.
  - Documentation is not included.
  - No X11 support.
  - No Java support.
  - No OpenMP support.
  - No JPEG, PNG or TIFF support.
  - No Cairo support.
  - No Tcl/Tk support.
  - No translations, only English.
  - The image does not have C, C++ or Fortran compilers.
  - Limited time zone data: `GMT`, `UTC` and `America/New_York`, see
    below if you need better time zone data.

## Usage

Get the image from [Docker
Hub](https://hub.docker.com/repository/docker/rhub/r-minimal):

    docker pull docker.io/rhub/r-minimal:latest

or from [GitHub
Packages](https://github.com/r-hub/r-minimal/packages/92808?version=latest):

    docker pull docker.pkg.github.com/r-hub/r-minimal/r-minimal:latest

## Platforms

All images are available on `linux/amd64` and `linux/arm64` platforms.

## Supported R versions

Currently we support the last patch version of the last five minor R
versions. The `latest` tag always uses the last R release.

| image     | R version   | tags                                                | note        |
| --------- | ----------- | --------------------------------------------------- | ----------- |
| R devel   | 4.4.0-devel | `devel`, `4.4.0`, `4.4`, `4.4.0-devel`, `4.4-devel` | Built daily |
| R next    | 4.3.1-RC    | `next`, `4.3.1`, `4.3`, `rc`, `4.3.1-rc`, `4.3-rc`  | Built daily |
| R release | 4.3.0       | `4.3.0`, `4.3`, `release`, `latest`                 |             |
| R 4.2.x   | 4.2.3       | `4.2.3`, `4.2`                                      |             |
| R 4.1.x   | 4.1.3       | `4.1.3`, `4.1`                                      |             |
| R 4.0.x   | 4.0.5       | `4.0.5`, `4.0`                                      |             |
| R 3.6.x   | 3.6.3       | `3.6.3`, `3.6`                                      |             |
| R 3.5.x   | 3.5.3       | `3.5.3`, `3.5`                                      |             |

## Dockerfile examples

One of our main goals is to be able to use `rhub/r-minimal` as a base
image, and easily add R packages from CRAN or GitHub to it, to create a
new image. Run `installr` from a `Dockerfile` to add R packages to the
`r-minimal` image:

    FROM rhub/r-minimal
    RUN installr praise
    CMD [ "R", "--slave", "-e", "cat(praise::praise())" ]

Package with compiled code:

    FROM rhub/r-minimal
    RUN installr -d glue

After the package(s) have been installed, `installr` removed the
compilers, as these are typically not needed on the final image. If you
want to keep them use `installr -c` instead of `installr -d`.

Package with system requirements:

    FROM rhub/r-minimal
    RUN installr -d -t linux-headers pingr
    CMD [ "R", "-q", "-e", "pingr::is_online() || stop('offline')" ]

Similarly to compilers, system packages are removed after the R packages
have been installed. If you want to keep (some of) them, use `installr
-a` instead of `installr -t`. (You can also mix the two.)

## Popular packages:

Hints on installing some popular R packages:

| package    | installr command                                                    | \~ image size               |
| ---------- | ------------------------------------------------------------------- | --------------------------- |
| data.table | `installr -d data.table`                                            | 39.1 MB                     |
| dplyr      | `installr -d dplyr`                                                 | 47.8 MB                     |
| ggplot2    | `installr -d -t gfortran ggplot2`                                   | 82.1 MB                     |
| h2o        | See `examples/h2o`.                                                 | 408.0 MB                    |
| knitr      | `installr -d knitr`                                                 | 79.2 MB                     |
| shiny      | See `examples/shiny`.                                               | 84.1 MB                     |
| sf         | See `examples/sf`.                                                  | 184.5 MB                    |
| plumber    | See `examples/plumber`.                                             | 103.1 MB                    |
| rmarkdown  | `installr -d rmarkdown`                                             | 161.3 MB (including pandoc) |
| rstan      | See `examples/rstan`.                                               | 344.4 MB                    |
| tidyverse  | See `examples/tidyverse`.                                           | 302.5 MB                    |
| xgboost    | `installr -d -t "gfortran libexecinfo-dev" -a libexecinfo xegboost` | 59.9 MB                     |

See also the `Dockerfile`s in the `examples` directory.

> Note that package and system dependencies change over time, so if any
> of these commands do not work any more, please [let us
> know](https://github.com/r-hub/r-minimal).

> See the \[examples/rmarkdown/Dockerfile\] for installing pandoc.

## Time zones

The image uses R’s internal time zone database, but most time zones are
removed from, to save space. The only supported ones are `GMT`, `UTC`
and `America/New_York`. If you need more time zones, then install
Alpine’s time zone package and point R to it:

    apk add --no-cache tzdata
    export TZDIR=/usr/share/zoneinfo

See also the discussion at
<https://github.com/r-hub/r-minimal/issues/24>

## Known failures and workarounds

  - The ps package needs the `linux-headers` Alpine package at compile
    time. Many tidyverse packages depend on ps, so they’ll need it as
    well:
    
        installr -d -t linux-headers ps

  - The arrow package are hard to install, because Alpine Linux does not
    have the required libraries. For the details, please see:
    <https://github.com/r-hub/r-minimal/issues/7>

  - The V8 packagees do not compile on aarch64 machines by default. On
    x86\_64 it installs fine:
    
        installr -d -t curl-dev V8
    
    This means that other packages that need V8 (e.g. rstan and prophet)
    do not work on aarch64, either.

  - The readxl package does not compile on Alpine Linux currently. You
    can install this branch from GitHub:
    
        installr -d gaborcsardi/readxl@fix/alpine-linux

  - The tidyverse package depends on readxl, so you’ll need to do the
    same:
    
        installr -d -t "curl-dev libxml2-dev linux-headers gfortran" \
            -a "libcurl libxml2" gaborcsardi/readxl@fix/alpine-linux tidyverse

  - To install the magick package, you need both the `imagemagick` and
    `imagemagick-dev` Alpine packages, both at install time and run
    time:
    
        installr -d -a "imagemagick imagemagick-dev" -t "curl-dev" magick

## License

See <https://www.r-project.org/Licenses/> for the R licenses

These Dockerfiles are licensed under the MIT License.

© [R Consortium](https://github.com/rconsortium)
