FROM ubuntu:latest

RUN apt-get update && \
	apt-get install -y unzip curl libcurl4 libssl1.0.0 && \
    curl https://minecraft.azureedge.net/bin-linux/bedrock-server-1.7.0.13.zip --output bedrock-server.zip && \
    unzip bedrock-server.zip -d bedrock-server && \
    rm bedrock-server.zip
	
EXPOSE 19132:19132/udp

RUN mv /bedrock-server/server.properties /bedrock-server/server.properties.default
RUN touch ops.json
RUN touch whitelist.json
RUN mkdir -p worlds

# Volume configuration
VOLUME ["/bedrock-server/server.properties", "/bedrock-server/ops.json", "/bedrock-server/whitelist.json", "/bedrock-server/worlds"]

# Copy server.properties only if not exist
RUN cp -n /bedrock-server/server.properties.default /bedrock-server/server.properties

WORKDIR /bedrock-server
ENV LD_LIBRARY_PATH=.
CMD ./bedrock_server