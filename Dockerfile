FROM debian:bullseye
MAINTAINER Kyle Wilcox <kyle@axiomdatascience.com>
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV NOTVISIBLE "in users profile"

RUN apt-get update && \
	apt-get install -y rsync && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "export VISIBLE=now" >> /etc/profile

COPY entrypoint.sh /entrypoint.sh
RUN chmod 744 /entrypoint.sh

RUN groupadd -r rsync -g 433 && \
	useradd -u 431 -r -g rsync -s /sbin/nologin -c "Docker image user" rsync

RUN mkdir /opt/rsyncd && \
	chown rsync:rsync /opt/rsyncd

EXPOSE 8873

USER rsync

CMD ["rsync_server"]
ENTRYPOINT ["/entrypoint.sh"]
