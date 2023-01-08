FROM java:openjdk-8u111-alpine AS budil
MAINTAINER wangziyang

# set environment
ENV JVM_XMS="1g" \
    JVM_XMX="1g" \
    JVM_XMN="512m" \
    JVM_MS="128m" \
    JVM_MMS="320m"

ENV ROCKETMQ_VERSION=4.9.4
ENV ROCKETMQ_HOME /opt/rocketmq-${ROCKETMQ_VERSION}
WORKDIR ${ROCKETMQ_HOME}


# 设置时间，东八区
RUN set -x \
    && rm -f /etc/localtime \
    && ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

ADD bin bin
ADD conf conf
ADD lib lib

RUN mkdir -p \
	/opt/logs \
	/opt/store

VOLUME /opt/logs \
       /opt/store

EXPOSE 9876
RUN chmod +x bin/mqnamesrv
CMD cd ${ROCKETMQ_HOME}/bin && export JAVA_OPT=" -Duser.home=/opt" && sh mqnamesrv