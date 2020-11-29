FROM node:14-alpine as builder

WORKDIR /workspace
RUN apk add --no-cache git
RUN git clone --branch v0.3.0 https://github.com/dennisreimann/stacking-sats-kraken.git .

RUN chown -R node .
USER node

RUN npm install

FROM node:14-alpine
WORKDIR /workspace
USER node
COPY --from=builder /workspace .
CMD npm start
