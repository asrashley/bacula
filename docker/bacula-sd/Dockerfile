FROM bacularis/bacularis-api-sd:5.4.0-alpine
ARG BACULA_GID
ARG BACULA_UID

RUN sed --in-place "s/^bacula:x:102:/bacula:x:${BACULA_GID}:/" /etc/group
RUN sed --in-place "s/^bacula:x:101:102:/bacula:x:${BACULA_UID}:${BACULA_GID}:/" /etc/passwd
