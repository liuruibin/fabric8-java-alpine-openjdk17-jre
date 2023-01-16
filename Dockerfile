FROM alpine:3.17.1

USER root

RUN mkdir -p /deployments

COPY run-java.sh /deployments/

ENV JAVA_APP_DIR=/deployments \
    JAVA_OPTIONS="-Dfile.encoding=utf-8" \
    LOG4J_FORMAT_MSG_NO_LOOKUPS=true \
    JAVA_MAJOR_VERSION=17 \
    JAVA_MAX_HEAP_RATIO=40

RUN apk add --update --no-cache tzdata curl fontconfig ttf-dejavu openjdk17-jre nss \
 && cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone && apk del tzdata \
 && echo "securerandom.source=file:/dev/urandom" >> /usr/lib/jvm/default-jvm/jre/lib/security/java.security \
 && curl -L --connect-timeout 60 -m 1800 https://fit2cloud-support.oss-cn-beijing.aliyuncs.com/xpack-license/get-validator-linux | sh \
 && rm -rf /tmp/* /var/tmp/* /var/cache/apk/* \
 && chmod 755 /deployments/run-java.sh

CMD [ "/deployments/run-java.sh" ]
