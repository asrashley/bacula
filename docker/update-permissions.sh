#!/bin/bash

source .env

set -x
chown -R bacula:bacula logs
chown -R bacula:bacula working
chown -R ${WWW_UID}:${WWW_GID} ./api/assets ./api/runtime
chown -R ${WWW_UID}:${WWW_GID} ./web/assets ./web/logs ./web/runtime
chown -R ${WWW_UID}:${WWW_GID} ./api/config
chown -R ${WWW_UID}:${WWW_GID} ./web/config

