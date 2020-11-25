FROM node:14-alpine as builder

WORKDIR /workspace
RUN apk add --no-cache git
RUN git clone --branch v2.0.2 https://github.com/janoside/btc-rpc-explorer.git .

RUN chown -R node .
USER node

RUN npm install

FROM node:14-alpine
WORKDIR /workspace
USER node
COPY --from=builder /workspace .
CMD npm start
EXPOSE 3002
