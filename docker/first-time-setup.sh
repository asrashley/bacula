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
        echo "Created bacula group GID=${BACULA_GID}"
    fi
    if [ -z "${BACULA_UID}" ]; then
        sudo adduser --system --no-create-home --gid ${BACULA_GID} bacula
        BACULA_UID=$(cat /etc/passwd | grep ^bacula | cut -d: -f3)
        echo "Created bacula user UID=${BACULA_UID}"
    fi

    if [ -z "${PG_GID}" ]; then
        sudo addgroup --system postgres
        PG_GID=$(cat /etc/group | grep ^postgres | cut -d: -f3)
        echo "Created postgres group GID=${PG_GID}"
    fi
    if [ -z "${PG_UID}" ]; then
        sudo adduser --system --no-create-home --gid ${PG_GID} postgres
        PG_UID=$(cat /etc/passwd | grep ^postgres | cut -d: -f3)
        echo "Created postgres user UID=${PG_UID}"
    fi

    if [ -z "${WWW_GID}" ]; then
        sudo addgroup --system www-data
        WWW_GID=$(cat /etc/group | grep ^www-data | cut -d: -f3)
        echo "Created www-data group GID=${WWW_GID}"
    fi
    if [ -z "${WWW_UID}" ]; then
        sudo adduser --system --no-create-home --gid ${WWW_GID} www-data
        WWW_UID=$(cat /etc/passwd | grep ^www-data | cut -d: -f3)
        echo "Created www-data user UID=${WWW_UID}"
    fi

    HOSTNAME=$(cat /etc/hostname)
    HOST_IP=$(dig +noall +answer ${HOSTNAME} | awk '/IN\s+A/ { print $5; exit }')
    DNS_SEARCH=$(cat /etc/resolv.conf | awk '/^search / { print $2 }')

    cat > .env <<EOF
    BACULA_KEY=$1
    BACULA_VERSION=15.0.3
    BACULARIS_VERSION=5.6.0
    BACULA_GID=${BACULA_GID}
    BACULA_UID=${BACULA_UID}
    PG_GID=${PG_GID}
    PG_UID=${PG_UID}
    WWW_GID=${WWW_GID}
    WWW_UID=${WWW_UID}
    EMAIL="${USER}@${DNS_SEARCH}"
    HOST_IP="${HOST_IP}"
    DNS_SERVER="8.8.8.8"
    DNS_SEARCH=${DNS_SEARCH}
EOF
fi

mkdir -p ./dir/working ./dir/logs ./dir/run ./dir/var
mkdir -p ./sd/working
mkdir -p ./api/logs/api ./api/logs/web ./api/config/api ./api/config/web
mkdir -p ./api/assets ./api/runtime ./api/working ./working/sd
mkdir -p ./web/logs/web ./web/assets ./web/runtime ./web/config/web

if [ ! -f api/config/api/bacularis.users ]; then
    # username=admin password=admin
    echo 'admin:$apr1$6hYFTlhE$0vj91PWcNlEjodBYuCEr9/' > api/config/api/bacularis.users
fi

if [ ! -f api/config/api/basic.conf ]; then
    cat > api/config/api/basic.conf <<EOF
[admin]
bconsole_cfg_path = ""

EOF
fi

if [ ! -f ./api/config/web/bacularis.users ]; then
    # username=admin password=admin
    echo 'admin:$apr1$6hYFTlhE$0vj91PWcNlEjodBYuCEr9/' > api/config/web/bacularis.users
fi

if [ ! -f web/config/web/bacularis.users ]; then
    # username=admin password=admin
    echo 'admin:$apr1$6hYFTlhE$0vj91PWcNlEjodBYuCEr9/' > web/config/web/bacularis.users
fi

sudo ./update-permissions.sh
