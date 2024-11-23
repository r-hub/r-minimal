FROM ghcr.io/r-hub/r-minimal/r-minimal AS build
FROM scratch

ENV _R_SHLIB_STRIP_=true
ENV TZ=UTC

COPY --from=build /usr/local /usr/local
COPY --from=build /etc /etc
COPY --from=build /bin/sh /bin/sh
COPY --from=build /bin/ls /bin/ls
COPY --from=build /bin/rm /bin/rm
COPY --from=build /bin/uname /bin/uname
COPY --from=build /usr/bin/which /usr/bin/which
COPY --from=build /lib/ld-musl-aarch64.so.1 /lib/ld-musl-aarch64.so.1
COPY --from=build /usr/lib/libreadline.so.8 /usr/lib/libreadline.so.8
COPY --from=build /usr/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
COPY --from=build /lib/libz.so.1 /lib/libz.so.1
COPY --from=build /usr/lib/libbz2.so.1 /usr/lib/libbz2.so.1
COPY --from=build /usr/lib/libpcre2-8.so.0 /usr/lib/libpcre2-8.so.0
COPY --from=build /usr/lib/liblzma.so.5 /usr/lib/liblzma.so.5
COPY --from=build /usr/lib/libgfortran.so.5 /usr/lib/libgfortran.so.5
COPY --from=build /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1

COPY --from=build /tmp /tmp

WORKDIR /root

CMD ["/usr/local/bin/R"]
