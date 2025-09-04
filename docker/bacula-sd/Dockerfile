FROM asrashley/bacula-base:15.0.2
ARG BACULA_GID
ARG BACULA_UID

VOLUME ["/opt/bacula/etc"]

EXPOSE 9103/tcp

ENTRYPOINT ["/opt/bacula/bin/bacula-sd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-sd.conf"]
