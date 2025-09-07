#!/bin/bash

source .env

set -x
chown -R bacula:bacula dir etc
chown -R bacula:bacula sd
chown -R ${WWW_UID}:${WWW_GID} ./api
chown -R ${WWW_UID}:${WWW_GID} ./web/assets ./web/logs ./web/runtime
chown -R ${WWW_UID}:${WWW_GID} ./web/config
