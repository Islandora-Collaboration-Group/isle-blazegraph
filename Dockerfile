FROM islandoracollabgroup/isle-tomcat:serverjre8

## Past usage was with version 2.1.0 but test using 2.1.4 (latest as of 2016) instead.
ENV BLZG_HOME=/usr/local/blazegraph \
    BLZG_VERSION=2.1.4 \
    CATALINA_BASE=/usr/local/tomcat \
    JAVA_MAX_MEM=${JAVA_MAX_MEM:-2G} \
    JAVA_MIN_MEM=${JAVA_MIN_MEM:-512M} \
    ## Per Gavin, we are no longer using -XX:+UseConcMarkSweepGC, instead G1GC.
    JAVA_OPTS='-Djava.awt.headless=true -server -Xmx${JAVA_MAX_MEM} -Xms${JAVA_MIN_MEM} -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Dcom.bigdata.rdf.sail.webapp.ConfigParams.propertyFile=/usr/local/blazegraph/RWStore.properties -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8' \

## Blazegraph Installation
RUN mkdir -p $BLZG_HOME && \
    chown -R tomcat:tomcat $BLZG_HOME && \
    cd /tmp/ && \
    curl -O -L https://sourceforge.net/projects/bigdata/files/bigdata/$BLZG_VERSION/blazegraph.war/download/blazegraph.war && \
    mv /tmp/blazegraph/blazegraph.war $CATALINA_HOME/webapps/ && \
    $CATALINA_HOME/bin/startup.sh && \  
    ## Docker Hub Auto-builds need some time.
    sleep 90 && \
    rm /tmp/blazegraph_conf/ && \   
    rm -rf /tmp/* /var/tmp/*

# Labels
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
VOLUME /usr/local/blazegraph/

EXPOSE 8084

ENTRYPOINT ["/init"]