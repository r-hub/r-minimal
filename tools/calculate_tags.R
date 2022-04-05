
docker <- function(cmd, args) {
  system2("docker", c(cmd, args), stdout = TRUE)
}

get_rver <- function(ver) {
  args <- c(
    "--rm", "-v", "`pwd`/tools:/tmp/tools",
    paste0("ghcr.io/r-hub/r-minimal/r-minimal:", ver),
    "R", "--slave", "-e", "\"cat(format(getRversion()))\""
  )
  docker("run", args)
}

get_rstr <- function(ver) {
  args <- c(
    "--rm", "-v", "`pwd`/tools:/tmp/tools",
    paste0("ghcr.io/r-hub/r-minimal/r-minimal:", ver),
    "R", "--slave", "-e", "\"cat(R.version.string)\""
  )
  docker("run", args)
}

get_tags <- function(ver) {
  args <- c(
    "--rm", "-v", "`pwd`/tools:/tmp/tools",
    paste0("ghcr.io/r-hub/r-minimal/r-minimal:", ver),
    "/tmp/tools/readme_tags.sh", ver
  )
  strsplit(docker("run", args), " ", fixed = TRUE)[[1]]
}

rv <- function(ver) {
  rver <- get_rver(ver)
  if (ver == "devel") {
    paste0(rver, "-devel")
  } else if (ver == "next") {
    rstr <- get_rstr(ver)
    rstr <- sub("^R version ", "", rstr)
    rstr <- sub(" [(].*$", "", rstr)
    rstr <- sub(" ", "-", rstr)
    rstr
  } else {
    rver
  }
}

rv_tags <- function(ver) {
  tags <- get_tags(ver)
  if (ver == "release") tags <- unique(c(tags, "release", "latest"))
  paste(paste0("`", tags, "`"), collapse = ", ")
}
