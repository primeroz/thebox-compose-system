FROM rust:1.44.1-slim-buster AS builder

RUN apt-get update \
  && apt-get install -y --no-install-recommends clang=1:7.* cmake=3.* git \
     libsnappy-dev=1.* curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-login --system --shell /bin/false --uid 1000 user

WORKDIR /home/user

RUN git clone --branch v0.8.6 https://github.com/romanz/electrs.git .

RUN chown -R user .

USER user

RUN cargo install --locked --path .

# Final Image
FROM debian:buster-slim

RUN adduser --disabled-login --system --shell /bin/false --home /data --uid 1000 user
USER user 

WORKDIR /data

COPY --from=builder /home/user/target/release/electrs /bin/electrs


# Electrum RPC
EXPOSE 50001

# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT

HEALTHCHECK CMD curl -fSs http://localhost:4224/ || exit 1
