FROM debian:bookworm
ARG BACULA_VERSION="15.0.2"
ARG BACULA_KEY
ARG BACULA_GID
ARG BACULA_UID
ARG PG_GID
ARG PG_UID
ARG EMAIL

ENV DEBIAN_VERSION=bookworm

RUN apt-get update && apt-get install -y curl ca-certificates wget gnupg2 \
       && wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc \
       && apt-key add Bacula-4096-Distribution-Verification-key.asc

COPY bacula-community.repo /etc/apt/sources.list.d/Bacula-Community.list

RUN sed -i s/BACULA_KEY/$(echo $BACULUA_KEY)/g /etc/apt/sources.list.d/Bacula-Community.list \
    && sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/apt/sources.list.d/Bacula-Community.list \
    && sed -i s/DEBIAN_VERSION/$(echo $DEBIAN_VERSION)/g /etc/apt/sources.list.d/Bacula-Community.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql postgresql-client bacula-postgresql

RUN sed -i "s/^bacula:x:102:/bacula:x:${BACULA_GID}:/" /etc/group
RUN sed -i "s/^postgres:x:105:/postgres:x:${PG_GID}:/" /etc/group
RUN sed -i "s/^bacula:x:100:102:/bacula:x:${BACULA_UID}:${BACULA_GID}:/" /etc/passwd
RUN sed -i "s/^postgres:x:102:105:/postgres:x:${PG_UID}:${PG_GID}:/" /etc/passwd

RUN mkdir -p /run/bacula
