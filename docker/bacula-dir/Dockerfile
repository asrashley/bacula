ARG BACULA_VERSION
FROM asrashley/bacula-base:${BACULA_VERSION:-15.0.3}

ARG BACULA_GID
ARG BACULA_UID

VOLUME ["/opt/bacula/etc"]

RUN apt install -y dnsutils python3 python3-psycopg2

EXPOSE 9101/tcp

ENTRYPOINT ["/opt/bacula/bin/bacula-dir"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-dir.conf"]
