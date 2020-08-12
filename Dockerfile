FROM islandoracollabgroup/isle-tomcat:1.5.1

## Blazegraph Environment
# @see: https://github.com/blazegraph/database/releases
ENV BLZG_CONF=/etc/bigdata \
    BLZG_DATA=/var/bigdata \
    BLZG_VERSION=2.1.5 \
    BLAZEGRAPH_ROOT_CATEGORY_LOG=WARN \
    BLAZEGRAPH_BIGDATA_LOG=WARN \
    BLAZEGRAPH_BIGDATA_BTREE_LOG=WARN \
    BLAZEGRAPH_BIGDATA_RULE_LOG=INFO \
    CATALINA_BASE=/usr/local/tomcat \
    JAVA_MAX_MEM=${JAVA_MAX_MEM:-2G} \
    JAVA_MIN_MEM=${JAVA_MIN_MEM:-512M} \
    ## Per Gavin, we are no longer using -XX:+UseConcMarkSweepGC, instead G1GC.
    JAVA_OPTS='-Djava.awt.headless=true -server -Xmx${JAVA_MAX_MEM} -Xms${JAVA_MIN_MEM} -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Dcom.bigdata.rdf.sail.webapp.ConfigParams.propertyFile=/etc/bigdata/RWStore.properties -Dlog4j.configuration=/etc/bigdata/log4j.properties -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8'

## Blazegraph Installation
RUN mkdir -p $BLZG_CONF && \
    chown -R tomcat:tomcat $BLZG_CONF && \
    chmod -R 755 $BLZG_CONF && \
    mkdir -p $BLZG_DATA && \
    chown -R tomcat:tomcat $BLZG_DATA && \
    chmod -R 755 $BLZG_DATA && \
    cd $CATALINA_HOME/webapps/ && \
    curl -L https://sourceforge.net/projects/bigdata/files/bigdata/$BLZG_VERSION/bigdata.war/download -o blazegraph.war && \
    $CATALINA_HOME/bin/startup.sh && \  
    ## Docker Hub Auto-builds need some time.
    sleep 90 && \ 
    rm -rf /tmp/* /var/tmp/*

## Labels
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="ISLE Blazegraph" \
      org.label-schema.description="Alternative triple and graph database" \
      org.label-schema.url="https://islandora-collaboration-group.github.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Islandora-Collaboration-Group/isle-blazegraph" \
      org.label-schema.vendor="Islandora Collaboration Group (ICG) - islandora-consortium-group@googlegroups.com" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      traefik.port="8084"

COPY rootfs /

## Volume Blazegraph Data
VOLUME /var/bigdata

EXPOSE 8084

ENTRYPOINT ["/init"]
