ARG ELECTRS_COMMIT=1cbc86fbfdb5680fea752377bf8f18ed417f0edd

FROM debian:buster as BUILD   
                                               
SHELL ["/bin/bash", "-c"]

COPY patch-json-import-chunks.diff /tmp/patch-json-import-chunks.diff
RUN apt-get -yqq update \
 && apt-get -yqq upgrade \
 && apt-get -yqq install clang cmake curl git \
 && curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain 1.48.0 \
 && source /root/.cargo/env \
 && mkdir -p /srv/electrs{_bitcoin,_liquid} \
 && git clone --no-checkout https://github.com/blockstream/electrs.git \
 && cd electrs \
 && git checkout $ELECTRS_COMMIT \
 && git apply /tmp/patch-json-import-chunks.diff \
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

FROM debian:buster

SHELL ["/bin/bash", "-c"]

COPY --from=BUILD /srv/electrs_bitcoin/bin/electrs /usr/local/bin/electrs

RUN addgroup --gid 1000 electrs
RUN adduser --disabled-login --system --shell /bin/false --home /srv/electrs --uid 1000 electrs
USER electrs
WORKDIR /srv/electrs

EXPOSE 50001 3000 4224

STOPSIGNAL SIGINT

#Placeholder
ENTRYPOINT ["/bin/sh"]
