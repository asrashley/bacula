FROM asrashley/bacula-base:15.0.2 AS base
FROM postgres:10
ARG PG_GID
ARG PG_UID

MAINTAINER eduardo@fametec.com.br

ENV POSTGRES_PASSWORD bacula

ENV POSTGRES_USER bacula

ENV POSTGRES_DB bacula

ENV POSTGRES_INITDB_ARGS '--encoding=SQL_ASCII --lc-collate=C --lc-ctype=C'

COPY --from=base /etc/apt/sources.list.d/Bacula-Community.list /etc/apt/sources.list.d/Bacula-Community.list

COPY --from=base /opt/bacula/scripts/make_postgresql_tables /docker-entrypoint-initdb.d/make_postgresql_tables

COPY --from=base /opt/bacula/scripts/grant_postgresql_privileges /docker-entrypoint-initdb.d/grant_postgresql_privileges

RUN sed -i "s/^postgres:x:999:/postgres:x:${PG_GID}:/" /etc/group
RUN sed -i "s/^postgres:x:999:999:/postgres:x:${PG_UID}:${PG_GID}:/" /etc/passwd

RUN { \
    echo '#!/bin/bash'; \
    echo 'sh /docker-entrypoint-initdb.d/make_postgresql_tables --username=$POSTGRES_USER'; \
    echo 'sh /docker-entrypoint-initdb.d/grant_postgresql_privileges --username=$POSTGRES_USER'; \
} >> /docker-entrypoint-initdb.d/deploy_database.sh \
&& chmod +x /docker-entrypoint-initdb.d/deploy_database.sh \
&& chown -R postgres. /docker-entrypoint-initdb.d

VOLUME ["/var/lib/postgresql/data"]

EXPOSE 5432/tcp
