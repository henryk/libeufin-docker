ARG DEBIAN_BASE_VERSION=11-slim
ARG LIBEUFIN_COMMIT=e9513cdd2c98b8329b31df4c50aa0efd84c0cf63

FROM debian:${DEBIAN_BASE_VERSION} as common-base

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

RUN mkdir -p /src/libeufin /app
COPY *.patch /src/
WORKDIR /src/libeufin

ARG LIBEUFIN_COMMIT
ENV LIBEUFIN_COMMIT=${LIBEUFIN_COMMIT}
RUN git init &&  \
    git remote add origin git://git.taler.net/libeufin && \
    git fetch origin ${LIBEUFIN_COMMIT} && \
    git reset --hard FETCH_HEAD

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
