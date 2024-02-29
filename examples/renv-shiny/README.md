
# Shiny app with renv

To build run:
```
docker build -t r-minimal-shiny-example .
```
and then run the app with:
```
docker run -it -p3838:3838 r-minimal-shiny-example
```

Go to http://localhost:3838/ to see the app.
