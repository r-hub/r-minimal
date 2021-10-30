#! /usr/bin/env Rscript

sin <- file("stdin")
writeLines(readLines(sin), "/tmp/card.Rmd")
close(sin)

rmarkdown::render("/tmp/card.Rmd")

pagedown::chrome_print("/tmp/card.html", extra_args = "--no-sandbox")

pdf <- readBin("/tmp/card.pdf", "raw", file.size("/tmp/card.pdf"))

con <- pipe("cat", "wb")
writeBin(pdf, con)
flush(con)
close(con)
