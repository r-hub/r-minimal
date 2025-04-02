
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Minimal Docker images for R

## What is R?

R is a free software environment for statistical computing and graphics.
It compiles and runs on a wide variety of UNIX platforms, Windows and
MacOS. See more at <https://www.r-project.org/>

## Goals and features

The main goal of these images is to keep them minimal, so they can be
used as part of a bigger (web) application, or as a base image.
Currently the (R 4.4.1) `r-minimal` image is 23.74MB compressed, and
45.88MB uncompressed.

All images use Alpine Linux.

The images include the `installr` tools that can install R packages from
CRAN or GitHub:

    ❯ installr -h
    Usage: ./installr [ -c | -d ] [ -e ] [ -a pkgs ] [ -t pkgs ] [ -r ] [ -p ] REMOTES ...

    Options:
      -c    install C and C++ compilers and keep them
      -d    install C and C++ compilers, temporarily
      -a    install Alpine packages and keep them
      -t    install Alpine packages, temporarily
      -p    do not remove pak after the installation (ignored if -r is given).
      -e    use renv to restore the renv.lock file if present.

    REMOTES may be:
      * package names from CRAN/Bioconductor, e.g.    ggplot2
      * slugs of GitHub repos, e.g.                   tidyverse/ggplot2
      * GitHub branch, tag or commit, e.g             tidyverse/ggplot2@v1.0.0
      * URLs to package .tar.gz files, e.g.           url::https://x.com/pkg.tar.gz
      * path to a local directory, e.g.               local::.

Recent r-minimal containers use [pak](https://github.com/r-lib/pak) for
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
- No OpenMP support. (But you can configure it for a package, see
  [examples/data.table](examples/data.table).)
- No JPEG, PNG or TIFF support.
- No Cairo support.
- No Tcl/Tk support.
- No translations, only English.
- The image does not have C, C++ or Fortran compilers.
- Limited time zone data: `GMT`, `UTC` and `America/New_York`, see below
  if you need better time zone data.

## Usage

Get the image from [Docker
Hub](https://hub.docker.com/repository/docker/rhub/r-minimal):

    docker pull docker.io/rhub/r-minimal:latest

or from [GitHub
Packages](https://github.com/r-hub/r-minimal/packages/92808?version=latest):

    docker pull ghcr.io/r-hub/r-minimal/r-minimal:latest

## Platforms

All images are available on `linux/amd64` and `linux/arm64` platforms.

## Supported R versions

Currently we support the last patch version of the last five minor R
versions. The `latest` tag always uses the last R release.

| image     | R version   | tags                                                              | note        |
|-----------|-------------|-------------------------------------------------------------------|-------------|
| R devel   | 4.6.0-devel | `devel`, `4.6.0`, `4.6`, `4.6.0-devel`, `4.6-devel`, `2025-04-02` | Built daily |
| R next    | 4.5.0-beta  | `next`, `4.5.0`, `4.5`, `beta`, `4.5.0-beta`, `4.5-beta`          | Built daily |
| R release | 4.4.3       | `4.4.3`, `4.4`, `release`, `latest`                               |             |
| R 4.3.x   | 4.3.3       | `4.3.3`, `4.3`                                                    |             |
| R 4.2.x   | 4.2.3       | `4.2.3`, `4.2`                                                    |             |
| R 4.1.x   | 4.1.3       | `4.1.3`, `4.1`                                                    |             |
| R 4.0.x   | 4.0.5       | `4.0.5`, `4.0`                                                    |             |
| R 3.6.x   | 3.6.3       | `3.6.3`, `3.6`                                                    |             |

## Daily R-devel builds

We tag our daily R-devel builds with the build date. These images can be
useful for tracking down bugs and regressions in R. E.g.:

``` sh
docker run -ti ghcr.io/r-hub/r-minimal/r-minimal:2022-11-25
```

The tags start on 2021-07-25. `linux/arm64` images are available from
2022-01-13.

## Dockerfile examples

One of our main goals is to be able to use `rhub/r-minimal` as a base
image, and easily add R packages from CRAN or GitHub to it, to create a
new image. Run `installr` from a `Dockerfile` to add R packages to the
`r-minimal` image:

``` dockerfile
FROM rhub/r-minimal
RUN installr praise
CMD [ "R", "--slave", "-e", "cat(praise::praise())" ]
```

Package with compiled code:

``` dockerfile
FROM rhub/r-minimal
RUN installr -d glue
```

After the package(s) have been installed, `installr` removed the
compilers, as these are typically not needed on the final image. If you
want to keep them use `installr -c` instead of `installr -d`.

Package with system requirements:

``` dockerfile
FROM rhub/r-minimal
RUN installr -d -t linux-headers pingr
CMD [ "R", "-q", "-e", "pingr::is_online() || stop('offline')" ]
```

Similarly to compilers, system packages are removed after the R packages
have been installed. If you want to keep (some of) them, use
`installr -a` instead of `installr -t`. (You can also mix the two.)

Using with renv:

To use `renv` to restore the `renv.lock` file, use the `-e` option:

``` dockerfile
FROM rhub/r-minimal
COPY .Rprofile .Rprofile
COPY renv renv
COPY renv.lock .
RUN installr -d -e
```

If you copy the entire folder with renv, including the `activate.R` and
`.Rprofile`, renv will bootstrap itself with the same version as the
lock and restore the packages with the proper versions. All the
necessary compilers and libraries needed at runtime need to be installed
with the `-a` and `-t` options. Please refer to
[examples/renv-shiny](examples/renv-shiny) for an example that install
shiny and rmarkdown in a container.

## Popular packages:

Hints on installing some popular R packages:

| package              | installr command                                                   | ~ image size (uncompressed)      |
|----------------------|--------------------------------------------------------------------|----------------------------------|
| data.table           | See [examples/data.table](examples/data.table) for OpenMP support  | 26.2 MB (50.0 MB)                |
| dplyr                | `installr -d dplyr`                                                | 31.9 MB (59.7 MB)                |
| ggplot2              | `installr -d -t gfortran ggplot2`                                  | 56.1 MB (93.5 MB)                |
| h2o                  | See [examples/h2o](examples/h2o).                                  | 354.0 MB (511.0 MB)              |
| knitr                | `installr -d knitr`                                                | 25.3 MB (48.3 MB)                |
| shiny                | See [examples/shiny](examples/shiny).                              | 49.8 MB (103.5 MB)               |
| sf                   | See [examples/sf](examples/sf).                                    | 79.7 MB (194.8 MB)               |
| plumber              | See [examples/plumber](examples/plumber).                          | 56.3 MB (127.7 MB)               |
| rmarkdown            | `installr -d rmarkdown`                                            | 58.1 MB (153.5 MB) (with pandoc) |
| tidyverse            | See [examples/tidyverse](examples/tidyverse).                      | 113.7 MB (208.6 MB)              |
| tidyverse w/o reprex | See [examples/tidyverse-minimal](examples/tidyverse-minimal).      | 66.5 MB (115.4 MB)               |
| rstan                | See [examples/rstan](examples/rstan).                              | 92.0 MB (298.5 MB)               |
| xgboost              | `installr -d -t "gfortran libexecinfo-dev" -a libexecinfo xgboost` | 35.5 MB (71.1 MB)                |

See also the `Dockerfile`s in the `examples` directory.

> Note that package and system dependencies change over time, so if any
> of these commands do not work any more, please [let us
> know](https://github.com/r-hub/r-minimal).

> See the [Dockerfile](examples/rmarkdown/Dockerfile) for installing
> pandoc.

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

- The arrow package needs a `Makevars` file to add a link flag. See the
  example `Dockerfile` in the [examples/arrow](examples/arrow)
  directory.

- The V8 packagees do not compile on aarch64 machines by default. On
  x86_64 it installs fine:

      installr -d -t curl-dev V8

  This means that other packages that need V8 (e.g. rstan and prophet)
  do not work on aarch64, either.

- To install the magick package, you need both the `imagemagick` and
  `imagemagick-dev` Alpine packages, both at install time and run time:

      installr -d -a "imagemagick imagemagick-dev" -t "curl-dev" magick

- pingr 2.0.4 does not build on Alpine, use the dev version:

      installr -d -t linux-headers r-lib/pingr

- Rcpp 1.0.13 [does not compile with R
  4.4.2](https://github.com/RcppCore/Rcpp/issues/1341). Use the dev
  version of Rcpp until a new version is released on CRAN. This affects
  all packages that depend on Rcpp, naturally. E.g. shiny, V8, rstan,
  odbc, golem, prophet, pagedown, plumber, sf, etc. See the updated
  \[examples\].

      installr -d Rcppcore/Rcpp

## License

See <https://www.r-project.org/Licenses/> for the R licenses

These Dockerfiles are licensed under the MIT License.

© [R Consortium](https://github.com/rconsortium)
