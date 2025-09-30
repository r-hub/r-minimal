alpine_version <- function() {
  lns <- readLines("Dockerfile")
  avl <- grep("^ARG ALPINE_VERSION=", lns, value = TRUE)[1]
  if (is.na(avl)) {
    stop("Cannot determine current Alpine version")
  }
  sub("^ARG ALPINE_VERSION=", "", avl)
}
