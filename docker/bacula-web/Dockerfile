FROM bacularis/bacularis-web:5.4.0-alpine
RUN sed --in-place 's/^bacula:x:102:/bacula:x:126:/' /etc/group
RUN sed --in-place 's/^bacula:x:101:102:/bacula:x:116:126:/' /etc/passwd
RUN sed --in-place 's/^nginx:x:101:nginx/nginx:x:33:nginx/g' /etc/group
RUN sed --in-place 's/^nginx:x:33:33:nginx:/nginx:x:100:101:nginx:/g' /etc/passwd
