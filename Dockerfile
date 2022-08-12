FROM debian:11-slim as common-base

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        openjdk-11-jre python3 python3-click python3-requests && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/app/bin:${PATH}

FROM common-base as builder-base

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        curl git gettext libpq-dev build-essential openjdk-11-jdk  \
        python3-pip python3-distutils && \
    rm -rf /var/lib/apt/lists/*

FROM builder-base as builder

RUN mkdir /src /app
WORKDIR /src
RUN git clone git://git.taler.net/libeufin
COPY *.patch .
WORKDIR /src/libeufin
RUN for i in ../*.patch; do patch -p1 < "$i"; done
RUN ./bootstrap
RUN ./configure --prefix=/app
RUN make assemble

FROM builder as builder-nexus
RUN make install-nexus install-cli

FROM builder as builder-sandbox
RUN make install-sandbox install-cli

FROM common-base as sandbox
COPY sandbox-entrypoint.sh /
COPY --from=builder-sandbox /app /app

EXPOSE 5002
ENTRYPOINT ["/sandbox-entrypoint.sh"]
CMD ["serve", "--port", "5002"]

FROM common-base as nexus
COPY --from=builder-nexus /app /app

EXPOSE 5001
ENTRYPOINT ["libeufin-nexus"]
CMD ["serve"]
