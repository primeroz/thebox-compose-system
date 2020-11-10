FROM rust:1.44.1-slim as BUILD

ARG  electrs_version=2f8759e940a3fe56002d653c29a480ed3bffa416

SHELL ["/bin/bash", "-c"]


RUN apt-get -yqq update \
 && apt-get -yqq upgrade \
 && apt-get -yqq install clang cmake curl git \
 && mkdir -p /srv/electrs{_bitcoin,_liquid} \
 && git clone --no-checkout https://github.com/blockstream/electrs.git \
 && cd electrs \
 && git checkout $electrs_version \
 #&& cp contrib/popular-scripts.txt /srv/electrs_bitcoin \
 && cargo install --root /srv/electrs_bitcoin --locked --path . --features electrum-discovery \
 #&& cargo install --root /srv/electrs_liquid --locked --path . --features electrum-discovery,liquid \
 && cd .. \
 && rm -fr /root/.cargo electrs \
 && strip /srv/electrs_*/bin/electrs \
 && apt-get --auto-remove remove -yqq --purge clang cmake manpages curl git \
 && apt-get clean \
 && apt-get autoclean \
 && rm -rf /usr/share/doc* /usr/share/man /usr/share/postgresql/*/man /var/lib/apt/lists/* /var/cache/* /tmp/* /root/.cache /*.deb /root/.cargo

FROM debian:buster@sha256:46d659005ca1151087efa997f1039ae45a7bf7a2cbbe2d17d3dcbda632a3ee9a

SHELL ["/bin/bash", "-c"]

COPY --from=BUILD /srv/electrs_bitcoin /srv/electrs

RUN adduser --disabled-login --system --shell /bin/false --home /srv/electrs --uid 1000 electrs
USER electrs
WORKDIR /srv/electrs

# Electrum RPC
EXPOSE 50001

# Prometheus monitoring
EXPOSE 4224

STOPSIGNAL SIGINT

ENTRYPOINT ["/bin/sh"]
