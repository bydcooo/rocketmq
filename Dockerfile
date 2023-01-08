FROM java:8

ENV ROCKETMQ_VERSION 4.9.4

ENV NAMESRV_HOME /home/rocketmq/namesrv-${ROCKETMQ_VERSION}

ENV JAVA_OPT "-Duser.home=/home/rocketmq"

WORKDIR ${NAMESRV_HOME}

RUN mkdir -p /home/rocketmq/logs /home/rocketmq/store

RUN curl https://dist.apache.org/repos/dist/release/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip -o rocketmq.zip \
    && unzip rocketmq.zip \
    && rm rocketmq.zip \
    && mv rocketmq-all-${ROCKETMQ_VERSION}-bin-release/* ./ \
    && rm -rf rocketmq-all-${ROCKETMQ_VERSION}-bin-release \
    && cd ${NAMESRV_HOME}/bin \
    && sed -i '70s/^/#/' runserver.sh \
    && sed -i '74,77s/^/#/' runserver.sh \
    && sed -i 's#-Xms[0-9]\+[gm]#-Xms512m#' runserver.sh \
    && sed -i 's#-Xmx[0-9]\+[gm]#-Xmx512m#' runserver.sh \
    && sed -i 's#-Xmn[0-9]\+[gm]#-Xmn128m#' runserver.sh \
    && sed -i 's#-XX:MetaspaceSize=[0-9]\+[gm]#-XX:MetaspaceSize=128m#' runserver.sh \
    && sed -i 's#-XX:MaxMetaspaceSize=[0-9]\+[gm]#-XX:MaxMetaspaceSize=320m#' runserver.sh \
    && chmod +x ./mqnamesrv

CMD cd ${NAMESRV_HOME}/bin && sh mqnamesrv

EXPOSE 9876

VOLUME ["/home/rocketmq/logs", "/home/rocketmq/store"]