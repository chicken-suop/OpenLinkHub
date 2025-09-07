FROM golang:1.23.8-bullseye AS build
ARG GIT_TAG
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y libudev-dev

WORKDIR /app
COPY . .
RUN go build .

FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y libudev-dev pciutils usbutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd openlinkhub && \
    groupadd i2c && \
    groupadd input && \
    useradd -g openlinkhub -G i2c,input -m -s /bin/bash openlinkhub

RUN mkdir -p /opt/OpenLinkHub
COPY --from=build /app/OpenLinkHub /opt/OpenLinkHub/
COPY --from=build /app/database /opt/OpenLinkHub/database
COPY --from=build /app/static /opt/OpenLinkHub/static
COPY --from=build /app/web /opt/OpenLinkHub/web

RUN chown -R openlinkhub:openlinkhub /opt/OpenLinkHub

WORKDIR /opt/OpenLinkHub
USER openlinkhub

ENTRYPOINT ["/opt/OpenLinkHub/OpenLinkHub"]