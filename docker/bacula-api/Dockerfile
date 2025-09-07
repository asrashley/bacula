ARG BACULARIS_VERSION
FROM bacularis/bacularis-api-sd:${BACULARIS_VERSION:-5.6.0}-alpine

ARG BACULA_GID
ARG BACULA_UID
ARG WWW_GID
ARG WWW_UID

RUN sed --in-place "s/^bacula:x:102:/bacula:x:${BACULA_GID}:/" /etc/group
RUN sed --in-place "s/^bacula:x:101:102:/bacula:x:${BACULA_UID}:${BACULA_GID}:/" /etc/passwd
RUN sed --in-place "s/^nginx:x:101:nginx/nginx:x:${WWW_GID}:nginx/g" /etc/group
RUN sed --in-place "s/^nginx:x:100:101:nginx:/nginx:x:${WWW_UID}:${WWW_GID}:nginx:/g" /etc/passwd
RUN apk add curl

COPY --chown=root:root docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh \
    && chown -R ${WWW_UID}:${WWW_GID} /var/www/bacularis/htdocs/assets /var/www/bacularis/protected/runtime
