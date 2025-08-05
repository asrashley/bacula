FROM Bertrezen/bacula-base:15.0.2

ARG BACULA_GID
ARG BACULA_UID

VOLUME ["/opt/bacula/etc", "/var/lib/bacula"]

RUN groupmod --gid ${BACULA_GID} bacula \
    && usermod --uid $BACULA_UID --gid $BACULA_GID bacula
RUN mkdir -p /run/bacula && chown bacula /run/bacula

ENTRYPOINT ["bacula-fd"]

CMD ["-f", "-c", "/opt/bacula/etc/bacula-fd.conf"]
