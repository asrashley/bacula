FROM Bertrezen/bacula-base:15.0.2
ARG BACULA_GID
ARG BACULA_UID

VOLUME ["/opt/bacula/etc"]

RUN mkdir -p /run/bacula

RUN apt install -y dnsutils

RUN groupmod --gid ${BACULA_GID} bacula \
    && usermod --uid ${BACULA_UID} --gid ${BACULA_GID} bacula

EXPOSE 9101/tcp

ENTRYPOINT ["/opt/bacula/bin/bacula-dir"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-dir.conf"]
