FROM debian:bookworm
ARG BACULA_VERSION="15.0.2"
ARG BACULA_KEY

ENV DEBIAN_VERSION=bookworm

# get your key on: https://www.bacula.org/bacula-binary-package-download/

ENV EMAIL=yu.grebenschikov@rko-group.ru

RUN apt-get update && apt-get install -y curl ca-certificates wget gnupg2 \
       && wget https://www.bacula.org/downloads/Bacula-4096-Distribution-Verification-key.asc \
       && apt-key add Bacula-4096-Distribution-Verification-key.asc

COPY bacula-community.repo /etc/apt/sources.list.d/Bacula-Community.list

RUN sed -i s/BACULA_KEY/$(echo $BACULUA_KEY)/g /etc/apt/sources.list.d/Bacula-Community.list \
    && sed -i s/BACULA_VERSION/$(echo $BACULA_VERSION)/g /etc/apt/sources.list.d/Bacula-Community.list \
    && sed -i s/DEBIAN_VERSION/$(echo $DEBIAN_VERSION)/g /etc/apt/sources.list.d/Bacula-Community.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y postgresql postgresql-client bacula-postgresql
