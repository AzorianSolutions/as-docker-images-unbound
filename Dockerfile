ARG DISTRO=debian
ARG DISTRO_TAG=11.1-slim

FROM ${DISTRO}:${DISTRO_TAG}

ARG AS_UNBOUND_VERSION=1.13.2

ENV UNBOUND_setuid=${UNBOUND_setuid:-unbound} \
  UNBOUND_setgid=${UNBOUND_setgid:-unbound} \
  UNBOUND_daemon=${UNBOUND_daemon:-no} \
  AS_UNBOUND_VERSION=${AS_UNBOUND_VERSION}

RUN apt update \
  && apt -y install g++ make pkg-config libssl-dev libexpat-dev

COPY src/unbound-${AS_UNBOUND_VERSION}.tar.gz /tmp/

COPY files/* /srv/

RUN mv /srv/entrypoint.sh / \
  && tar -xvzf /tmp/unbound-${AS_UNBOUND_VERSION}.tar.gz -C /tmp \
  && cd /tmp/unbound-${AS_UNBOUND_VERSION} \
  && ./configure --prefix="" --exec-prefix=/usr --sysconfdir=/etc/unbound \
  && make \
  && make install \
  && cd / \
  && rm -rf /tmp/unbound-${AS_UNBOUND_VERSION} \
  && mkdir -p /etc/unbound/conf.d \
  && mkdir -p /var/run/unbound \
  && adduser --system --disabled-login --no-create-home --home /tmp --shell /bin/false --group ${UNBOUND_setgid} 2>/dev/null \
  && chown -R ${UNBOUND_setuid}:${UNBOUND_setgid} /etc/unbound/conf.d /var/run/unbound

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD ["/usr/sbin/unbound", "-d", "-c", "/etc/unbound/unbound.conf"]
