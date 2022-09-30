# ARG FRM='testdasi/pihole-base-buster-plus'
ARG FRM='milindpatel63/pihole-base-plus'
ARG TAG='latest'

FROM ${FRM}:${TAG}
ARG FRM
ARG TAG

ADD stuff /temp

RUN /bin/bash /temp/install.sh \
    && rm -f /temp/install.sh

VOLUME ["/etc/pihole"]

#EXPOSE 80

#EXPOSE 53

RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM} with tag ${TAG}" >> /build_date.info

COPY stuff/healthz.php /var/www/html/admin/healthz.php

ENTRYPOINT [ \
    "unshare", "--pid", "--fork", "--kill-child=SIGTERM", "--mount-proc", \
    "perl", "-e", "$SIG{INT}=''; $SIG{TERM}=''; exec @ARGV;", "--", \
    "/s6-init" ]