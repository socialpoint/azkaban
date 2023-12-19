FROM openjdk:8 as builder
ENV CHANGE 1
ENV VERSION 3.70.2

RUN git clone https://github.com/sp-roger-bosch/azkaban
WORKDIR /azkaban
RUN git checkout azkaban_mysql_8
RUN ./gradlew build -x test
RUN mkdir -p /opt/azkaban/sql /opt/azkaban/executor /opt/azkaban/web
RUN tar xzf /azkaban/azkaban-db/build/distributions/azkaban-db-${VERSION}.tar.gz --strip-components=1 -C /opt/azkaban/sql
RUN tar xzf /azkaban/azkaban-exec-server/build/distributions/azkaban-exec-server-${VERSION}.tar.gz --strip-components=1 -C /opt/azkaban/executor
RUN tar xzf /azkaban/azkaban-web-server/build/distributions/azkaban-web-server-${VERSION}.tar.gz --strip-components=1 -C /opt/azkaban/web

FROM ubuntu:18.04
ENV TINI_VERSION v0.18.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
RUN apt-get update && apt-get install -y openjdk-8-jre curl openssh-client python-pip jq && apt-get clean
RUN pip install awscli

COPY --from=builder /opt/azkaban /opt/azkaban
ADD files/entrypoint.sh /
ADD files/azkaban.properties.template /tmp/
ADD files/azkaban-users.xml.template /tmp/
ADD files/executor.commonprivate.properties /opt/azkaban/executor/plugins/jobtypes/

ENTRYPOINT ["/tini", "-g", "--", "/entrypoint.sh"]
