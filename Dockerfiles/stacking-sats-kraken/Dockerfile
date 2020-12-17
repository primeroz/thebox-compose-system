FROM node:14-alpine as builder

WORKDIR /workspace
RUN apk add --no-cache git
RUN git clone --branch v0.3.0 https://github.com/dennisreimann/stacking-sats-kraken.git .

RUN chown -R node .
USER node

COPY price-patch.diff /tmp/price-patch.diff
RUN git apply /tmp/price-patch.diff && \
    npm install

FROM golang:1.15-alpine as simplepush

WORKDIR /simplepush
RUN apk add --no-cache git make gcc musl-dev
RUN git clone --branch v0.3 https://github.com/rck/simplepush.git

RUN cd simplepush && \
    go mod init simplepush && \
    make

FROM node:14-alpine
WORKDIR /workspace

RUN apk add --no-cache bash

COPY --from=builder /workspace .
COPY --from=simplepush /simplepush/simplepush/simplepush /usr/local/bin/simplepush

COPY scripts/* /usr/local/bin/
RUN chmod a+x /usr/local/bin/*

USER node
CMD ["npm", "run"]
