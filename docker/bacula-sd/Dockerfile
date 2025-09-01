FROM bacularis/bacularis-api-sd:5.4.0-alpine
ARG BACULA_GID
ARG BACULA_UID
ARG WWW_GID
ARG WWW_UID

RUN sed --in-place "s/^bacula:x:102:/bacula:x:${BACULA_GID}:/" /etc/group
RUN sed --in-place "s/^bacula:x:101:102:/bacula:x:${BACULA_UID}:${BACULA_GID}:/" /etc/passwd
RUN sed --in-place "s/^nginx:x:101:nginx/nginx:x:${WWW_GID}:nginx/g" /etc/group
RUN sed --in-place "s/^nginx:x:100:101:nginx:/nginx:x:${WWW_UID}:${WWW_GID}:nginx:/g" /etc/passwd
RUN apk add curl