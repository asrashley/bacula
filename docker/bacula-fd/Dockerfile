ARG BACULA_VERSION
FROM asrashley/bacula-base:${BACULA_VERSION:-15.0.3}

ENV BACULA_EMAIL="bacula@local"

VOLUME ["/opt/bacula/etc", "/var/lib/bacula"]

ENTRYPOINT ["/opt/bacula/bin/bacula-fd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-fd.conf"]

EXPOSE 9102/tcp
