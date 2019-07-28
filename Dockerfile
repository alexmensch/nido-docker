FROM arm32v6/python:3.7-alpine AS nido-base

# See: https://github.com/docker/hub-feedback/issues/1261
COPY qemu-arm-static /usr/bin

RUN apk add tzdata \
    && cp /usr/share/zoneinfo/UTC /etc/localtime \
    && echo "UTC" > /etc/timezone \
    && apk del tzdata

RUN pip install pip --upgrade

RUN apk add build-base \
    && pip install nido \
    && apk del build-base

WORKDIR /app
VOLUME /app/instance
VOLUME /app/log
