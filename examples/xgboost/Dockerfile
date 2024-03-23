
FROM rhub/r-minimal

RUN mkdir -p ~/.R && echo 'CXX17FLAGS+=-DDMLC_LOG_STACK_TRACE=0 -DDMLC_USE_FOPEN64=0' >> ~/.R/Makevars

RUN installr -d -t "gfortran" xgboost
