#!/bin/bash
BACULA_GID=$(cat /etc/group | grep ^bacula | cut -d: -f3)
BACULA_UID=$(cat /etc/passwd | grep ^bacula | cut -d: -f3)
PG_GID=$(cat /etc/group | grep ^postgres | cut -d: -f3)
if [ -z "${PG_GID}" ]; then
    PG_GID=$(cat /etc/group | grep ^mysql | cut -d: -f3)
fi
PG_UID=$(cat /etc/passwd | grep ^postgres | cut -d: -f3)
if [ -z "${PG_UID}" ]; then
    PG_UID=$(cat /etc/passwd | grep ^mysql | cut -d: -f3)
fi

if [ ! -f .env ]; then
    if [ -z "${BACULA_GID}" ]; then
        sudo addgroup --system bacula
        BACULA_GID=$(cat /etc/group | grep ^bacula | cut -d: -f3)
    fi
    if [ -z "${BACULA_UID}" ]; then
        sudo adduser --system --no-create-home --gid ${BACULA_GID} bacula
        BACULA_GID=$(cat /etc/passwd | grep ^bacula | cut -d: -f3)
    fi
    if [ -z "${PG_GID}" ]; then
        sudo addgroup --system postgres
        PG_GID=$(cat /etc/group | grep ^postgres | cut -d: -f3)
    fi
    if [ -z "${PG_UID}" ]; then
        sudo adduser --system --no-create-home --gid ${PG_GID} postgres
        PG_UID=$(cat /etc/passwd | grep ^postgres | cut -d: -f3)
    fi
    cat > .env <<EOF
    BACULA_KEY=$1
    BACULA_VERSION=15.0.2
    BACULA_GID=${BACULA_GID}
    BACULA_UID=${BACULA_UID}
    PG_GID=${PG_GID}
    PG_UID=${PG_UID}
    EMAIL=${USER}
    DNS_SERVER="8.8.8.8"
    DNS_SEARCH="home.local"
EOF
fi

mkdir -p logs/api logs/dir logs/web
chown -R bacula:bacula logs
mkdir -p working/api working/dir working/fd working/sd working/web
chown -R bacula:bacula working

if [ ! -f config/api/bacularis.users ]; then
    # username=admin password=admin
    cat > config/api/bacularis.users <<EOF
admin:$apr1$6hYFTlhE$0vj91PWcNlEjodBYuCEr9/
EOF
fi

if [ ! -f config/web/bacularis.users ]; then
    # username=admin password=admin
    cat > config/web/bacularis.users <<EOF
admin:$apr1$6hYFTlhE$0vj91PWcNlEjodBYuCEr9/
EOF
fi
chown -R bacula:bacula config
