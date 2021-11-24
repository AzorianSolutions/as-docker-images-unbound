ARG DISTRO=alpine
ARG DISTRO_TAG=3.14

FROM ${DISTRO}:${DISTRO_TAG}

ARG AS_UNBOUND_VERSION=4.5.7

ENV UNBOUND_setuid=${UNBOUND_setuid:-unbound} \
  UNBOUND_setgid=${UNBOUND_setgid:-unbound} \
  UNBOUND_daemon=${UNBOUND_daemon:-no} \
  AS_UNBOUND_VERSION=${AS_UNBOUND_VERSION}

RUN apk update \
  && apk add g++ make pkgconfig openssl-dev boost-dev boost-serialization \
  boost-system boost-thread boost-context lua5.3-dev luajit-dev expat-dev

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
  && addgroup ${UNBOUND_setgid} 2>/dev/null \
  && adduser -S -s /bin/false -H -h /tmp -G ${UNBOUND_setgid} ${UNBOUND_setuid} 2>/dev/null \
  && chown -R ${UNBOUND_setuid}:${UNBOUND_setgid} /etc/unbound/conf.d /var/run/unbound

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["/usr/sbin/unbound", "-d", "-c", "/etc/unbound/unbound.conf"]
