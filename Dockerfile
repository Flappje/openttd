FROM ubuntu:22.04

ARG OPENTTD_VERSION="13.4"
ARG OPENGFX_VERSION="7.1"

ADD prepare.sh /tmp/prepare.sh
ADD cleanup.sh /tmp/cleanup.sh
ADD buildconfig /tmp/buildconfig
ADD --chown=1000:1000 openttd.sh /openttd.sh

RUN chmod +x /tmp/prepare.sh /tmp/cleanup.sh /openttd.sh
RUN /tmp/prepare.sh \
    && /tmp/cleanup.sh

VOLUME /home/openttd/.openttd

EXPOSE 3979/tcp
EXPOSE 3979/udp

USER openttd
ENTRYPOINT [ "/openttd.sh" ]
