#!/bin/bash

source .env

set -x
chown -R bacula:bacula dir etc
chown -R bacula:bacula sd
chown -R ${WWW_UID}:${WWW_GID} ./api ./web

if [ ! -z "${REAL_USER}" ]; then
    chown -R ${REAL_USER} docker-compose.yml *.sh .env bacula-* ../.git
fi