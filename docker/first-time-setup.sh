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

WWW_GID=$(cat /etc/group | grep ^www-data | cut -d: -f3)
if [ -z "${WWW_GID}" ]; then
    WWW_GID=$(cat /etc/group | grep ^nginx | cut -d: -f3)
fi

WWW_UID=$(cat /etc/passwd | grep ^www-data | cut -d: -f3)
if [ -z "${WWW_UID}" ]; then
    WWW_UID=$(cat /etc/passwd | grep ^nginx | cut -d: -f3)
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

    if [ -z "${WWW_GID}" ]; then
        sudo addgroup --system www-data
        WWW_GID=$(cat /etc/group | grep ^www-data | cut -d: -f3)
    fi
    if [ -z "${WWW_UID}" ]; then
        sudo adduser --system --no-create-home --gid ${PG_GID} www-data
        PG_UID=$(cat /etc/passwd | grep ^www-data | cut -d: -f3)
    fi

    cat > .env <<EOF
    BACULA_KEY=$1
    BACULA_VERSION=15.0.2
    BACULA_GID=${BACULA_GID}
    BACULA_UID=${BACULA_UID}
    PG_GID=${PG_GID}
    PG_UID=${PG_UID}
    WWW_GID=${WWW_GID}
    WWW_UID=${WWW_UID}
    EMAIL=${USER}
    DNS_SERVER="8.8.8.8"
    DNS_SEARCH="home.local"
EOF
fi

mkdir -p logs/api logs/dir logs/web
mkdir -p working/api working/dir working/fd working/sd working/web
mkdir -p ./api/logs/api ./api/logs/web ./api/config/api ./api/config/web
mkdir -p ./api/assets ./api/runtime ./api/working ./working/sd
mkdir -p ./web/logs/web ./web/assets ./web/runtime ./web/config/web

if [ ! -f api/config/api/bacularis.users ]; then
    # username=admin password=admin
    cat > api/config/api/bacularis.users <<EOF
admin:$apr1$6hYFTlhE$0vj91PWcNlEjodBYuCEr9/
EOF
fi

if [ ! -f ./api/config/web/bacularis.users ]; then
    # username=admin password=admin
    cat > ./api/config/web/bacularis.users <<EOF
admin:$apr1$6hYFTlhE$0vj91PWcNlEjodBYuCEr9/
EOF
fi

if [ ! -f web/config/web/bacularis.users ]; then
    cat > web/config/web/bacularis.users <<EOF
admin:$apr1$6hYFTlhE$0vj91PWcNlEjodBYuCEr9/
EOF
fi

sudo ./update-permissions.sh
