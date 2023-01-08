#
# Program:
#     Make RocketMQ docker image
#
#

FROM onesoso/java:8

MAINTAINER wangziyang

ARG version

# Rocketmq version
ENV ROCKETMQ_VERSION ${version}

# Rocketmq home
ENV ROCKETMQ_HOME /opt/rocketmq

WORKDIR  ${ROCKETMQ_HOME}

# get rocketmq program
RUN curl https://dist.apache.org/repos/dist/release/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip -o rocketmq.zip \
 && unzip rocketmq.zip \
 && mv rocketmq-all*/* . \
 && rmdir rocketmq-all*  \
 && rm rocketmq.zip

# add scripts
COPY scripts/ ${ROCKETMQ_HOME}/bin/

VOLUME ${ROCKETMQ_HOME}/conf 

# expose namesrv port
EXPOSE 9876

# add customized scripts for mqnamesrv
RUN mv ${ROCKETMQ_HOME}/bin/mqnamesrv-customize ${ROCKETMQ_HOME}/bin/mqnamesrv \
 && chmod +x ${ROCKETMQ_HOME}/bin/mqnamesrv

# add customized scripts for runserver.sh
RUN mv ${ROCKETMQ_HOME}/bin/runserver-customize.sh ${ROCKETMQ_HOME}/bin/runserver.sh \
 && chmod +x ${ROCKETMQ_HOME}/bin/runserver.sh

# expose broker ports
EXPOSE 10909 10911

# add customized scripts for mqbroker
RUN mv ${ROCKETMQ_HOME}/bin/mqbroker-customize ${ROCKETMQ_HOME}/bin/mqbroker \
 && chmod +x ${ROCKETMQ_HOME}/bin/mqbroker

# add customized scripts for runuroker.sh
RUN mv ${ROCKETMQ_HOME}/bin/runbroker-customize.sh ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod +x ${ROCKETMQ_HOME}/bin/runbroker.sh

# export Java options
RUN export JAVA_OPT=" -Duser.home=/opt"

WORKDIR ${ROCKETMQ_HOME}/bin
