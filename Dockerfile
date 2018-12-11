FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y unzip curl libcurl4 libssl1.0.0
RUN curl https://minecraft.azureedge.net/bin-linux/bedrock-server-1.7.0.13.zip --output bedrock-server.zip
RUN unzip bedrock-server.zip -d bedrock-server
RUN rm bedrock-server.zip

VOLUME /minecraft
EXPOSE 19132

WORKDIR /minecraft
ENV LD_LIBRARY_PATH=.
CMD ./bedrock_server
