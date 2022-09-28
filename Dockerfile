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

RUN echo "$(date "+%d.%m.%Y %T") Built from ${FRM} with tag ${TAG}" >> /build_date.info

ENTRYPOINT [ "/s6-init" ]
