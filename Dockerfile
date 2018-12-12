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

	curl https://minecraft.azureedge.net/bin-linux/bedrock-server-1.8.0.24.zip --output bedrock-server.zip && \
	useradd -ms /bin/bash bedrock && \
	unzip bedrock-server.zip -d /home/bedrock/bedrock_server && \
	rm bedrock-server.zip && \
	su - bedrock -c "mkdir -p /home/bedrock/bedrock_server/data/worlds" && \
	chown -R bedrock:bedrock /home/bedrock/bedrock_server/data/worlds && \

	mv /home/bedrock/bedrock_server/server.properties /home/bedrock/bedrock_server/server.properties.default && \
	mv /home/bedrock/bedrock_server/permissions.json /home/bedrock/bedrock_server/permissions.json.default && \

	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 19132:19132/udp

# Entry
COPY ./startup.sh /home/bedrock
RUN ["chmod", "+x", "/home/bedrock/startup.sh"]

# If you enable the USER below, there will be permission issues with shared volumes
# USER bedrock

ENV LD_LIBRARY_PATH=.

# Volume configuration
# VOLUME ["/home/bedrock/bedrock_server/server.properties", "/home/bedrock/bedrock_server/permissions.json", "/home/bedrock/bedrock_server/whitelist.json", "/home/bedrock/bedrock_server/worlds"]

# Added bash so you can drop to a shell to resolve errors
ENTRYPOINT /home/bedrock/startup.sh && /bin/bash