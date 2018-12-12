# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.11

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update
RUN apt-get -y install unzip libcurl4 curl

RUN curl https://minecraft.azureedge.net/bin-linux/bedrock-server-1.8.0.24.zip --output bedrock-server.zip
RUN useradd -ms /bin/bash bedrock
RUN unzip bedrock-server.zip -d bedrock_server
RUN rm bedrock-server.zip

RUN su - bedrock -c "mkdir -p bedrock_server/data/worlds"
RUN chown -R bedrock:bedrock /home/bedrock/bedrock_server/data/worlds

RUN cp bedrock_server/server.properties bedrock_server/server.properties.default
RUN rm bedrock_server/server.properties

RUN cp bedrock_server/permissions.json bedrock_server/permissions.json.default
RUN rm bedrock_server/permissions.json

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 19132:19132/udp

# Entry
COPY ./startup.sh /home/bedrock
RUN ["chmod", "+x", "/home/bedrock/startup.sh"]

# If you enable the USER below, there will be permission issues with shared volumes
USER bedrock

ENV LD_LIBRARY_PATH=.

# Volume configuration
VOLUME ["/home/bedrock/bedrock_server/server.properties", "/home/bedrock/bedrock_server/permissions.json", "/home/bedrock/bedrock_server/whitelist.json", "/home/bedrock/bedrock_server/worlds"]

# Added bash so you can drop to a shell to resolve errors
ENTRYPOINT /home/bedrock/startup.sh && /bin/bash