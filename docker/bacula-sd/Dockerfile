ARG BACULA_VERSION
FROM asrashley/bacula-base:${BACULA_VERSION:-15.0.3}

ENV BACULA_EMAIL="bacula@local"

VOLUME ["/opt/bacula/etc"]

EXPOSE 9103/tcp

ENTRYPOINT ["/opt/bacula/bin/bacula-sd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-sd.conf"]
