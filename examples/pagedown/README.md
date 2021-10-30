
# pagedown

This is an [`rhub/r-minimal`](https://github.com/r-hub/r-minimal)
Docker image for [`rstudio/pagedown`](https://github.com/rstudio/pagedown).

Currently it is about 560MB. It could be a bit smaller if the
installed R packages were trimmed from documentation, etc., but probably
not much smaller since it needs to include pandoc and chromium.

The `pagedown.sh` script on the image converts an `.Rmd` file from
the standard input to a `.pdf` file on the standard output.
See this file to create your own workflow.

Example:

```
docker build -t rhub/pagedown .
cat card.Rmd |  docker run -i rhub/pagedown pagedown.sh > card.pdf
```

## License

See https://www.r-project.org/Licenses/ for the R licenses

These Dockerfiles are licensed under the MIT License.

(c) [R Consortium](https://github.com/rconsortium)
