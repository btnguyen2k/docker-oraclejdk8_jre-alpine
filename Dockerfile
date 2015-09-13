# Dockerfile to build a minimum Java runtime for Java applications
# by Thanh Nguyen <btnguyen2k@gmail.com>

# Ref: https://developer.atlassian.com/blog/2015/08/minimal-java-docker-containers/

FROM alpine:3.2
MAINTAINER Thanh Nguyen <btnguyen2k@gmail.com>

# Java Version
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 60
ENV JAVA_VERSION_BUILD 27
ENV JAVA_PACKAGE       jre
ENV JAVA_OUTPUT_DIR    ${JAVA_PACKAGE}1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}

# Install dependencies
RUN \
	mkdir -p /tmp && \
	apk --update add wget ca-certificates tar && \
	cd /tmp && \
	wget --no-check-certificate https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk && \
	apk add --allow-untrusted /tmp/glibc-2.21-r2.apk && \
	rm -f /tmp/glibc-2.21-r2.apk

# Download & Extract Oracle Java
# Ref: http://stackoverflow.com/questions/10268583/downloading-java-jdk-on-linux-via-wget-is-shown-license-page-instead
RUN \
	cd /tmp && \
	wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie; s_cc=true; gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk6downloads-1902814.html; s_sq=%5B%5BB%5D%5D; gpv_p24=no%20value" -qO- http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz | tar -xzf - && \
	mv /tmp/${JAVA_OUTPUT_DIR} /usr/local && \
	ln -s /usr/local/${JAVA_OUTPUT_DIR} /usr/local/java && \
	ln -s /usr/local/java/bin/* /usr/local/bin/

ENV JAVA_HOME /usr/local/java

