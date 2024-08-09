
last <- 1
sleep <- 2

get_builds_page <- function(page) {
  pkgs <- gh::gh(
    "/orgs/{org}/packages/{package_type}/{package_name}/versions",
    org = "r-hub",
    package_type = "container",
    package_name = URLencode("r-minimal/r-minimal", reserved=TRUE),
    per_page = 100,
    page = page
  )
  rev(pkgs)
}

tag_pkg <- function(pkg) {
  out <- processx::run(
    "skopeo",
    c("inspect", "--no-tags", "--override-os", "linux", "--override-arch", "amd64",
      paste0("docker://ghcr.io/r-hub/r-minimal/r-minimal@", pkg$name)
    )
  )
  jout <- jsonlite::fromJSON(out$stdout)
  # not a real image, but metadata, nothing to do
  if (jout[["Architecture"]] == "unknown") return()

  message("PACKAGE ", pkg$name)
  verout <- processx::run(
    "docker",
    c("run", paste0("ghcr.io/r-hub/r-minimal/r-minimal@", pkg$name),
      "R", "-q", "--slave", "-e", "cat(R.Version()$version.string)"
    )
  )
  if (!grepl("development", verout$stdout)) return()

  date <- rematch2::re_match(
    verout$stdout,
    "[0-9][0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9]"
  )[[".match"]]

  if (is.na(date)) stop("Could not find date in version string")

  message("  -> ", date)
  processx::run(
    "regctl",
    c("image", "copy",
      paste0("ghcr.io/r-hub/r-minimal/r-minimal@", pkg$name),
      paste0("ghcr.io/r-hub/r-minimal/r-minimal:", date)
    ),
    echo = TRUE
  )
}

tag_builds_page <- function(page) {
  message("PAGE ", page)
  pkgs <- get_builds_page(page)
  for (idx in seq_along(pkgs)) {
    pkg <- pkgs[[idx]]
    message("[", idx, "/", length(pkgs), "] ", appendLF = FALSE)
    tag_pkg(pkg)
    Sys.sleep(sleep)
  }
}

fill_in_gaps <- function() {
  begin <- as.Date("2021-07-25")
  end <- Sys.Date()
  dts <- rev(as.character(seq(begin, end, by = 1)))
  out <- processx::run(
    "regctl",
    c("tag", "ls", "ghcr.io/r-hub/r-minimal/r-minimal")
  )$stdout
  alltags <- rev(strsplit(out, "\n", fixed = TRUE)[[1]])
  dtags <- grep(
    "^[0-9][0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9]$",
    alltags,
    value = TRUE
  )
  last <- dtags[1]
  for (day in dts) {
    if (day %in% dtags) {
      last <- day
    } else {
      processx::run(
        "regctl",
        c("image", "copy",
          paste0("ghcr.io/r-hub/r-minimal/r-minimal:", last),
          paste0("ghcr.io/r-hub/r-minimal/r-minimal:", day)
        ),
        echo = TRUE
      )
    }
  }
}

add_date_tags_main <- function() {
  for (page in last:1) {
    tag_builds_page(page)
    processx::run("docker", c("system", "prune", "-f"))
  }
  fill_in_gaps()
}

if (is.null(sys.calls())) {
  add_date_tags_main()
}
