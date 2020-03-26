
FROM rhub/r-minimal

RUN installr -d \
   -t "R-dev file automake autoconf linux-headers" \
   -a "libxml2-dev icu-libs" `# needed for xml2 and stringr`  \
   tidyverse/readxl `# CRAN version does not compile on alpine` \
   tidyverse
