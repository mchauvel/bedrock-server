# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.11

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update && \
	apt-get -y install unzip libcurl4 curl && \

	curl https://minecraft.azureedge.net/bin-linux/bedrock-server-1.12.1.1.zip --output bedrock-server.zip && \

	unzip bedrock-server.zip -d /home/bedrock && \
	rm bedrock-server.zip && \
	mkdir -p /home/bedrock/worlds && \

	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 19132:19132/udp

# Entry
COPY ./startup.sh /home/bedrock
RUN ["chmod", "+x", "/home/bedrock/startup.sh"]


ENV LD_LIBRARY_PATH=.

# Volume configuration
VOLUME ["/home/bedrock/worlds"]

# Added bash so you can drop to a shell to resolve errors
ENTRYPOINT /home/bedrock/startup.sh
