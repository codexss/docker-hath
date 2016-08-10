FROM anapsix/alpine-java:7
MAINTAINER Luis Alvarado <alvaradorocks@gmail.com>

# Install dependencies 
RUN apk --no-cache add curl sqlite unzip

# Common
ENV HatH_VERSION 1.2.6
ENV HatH_DOWNLOAD_URL https://repo.e-hentai.org/hath/HentaiAtHome_$HatH_VERSION.zip
ENV HatH_DOWNLOAD_SHA256 1ac731049a3d6f860f897430bc0ab043e37d5f045c990fac214b680e53e36c97
ENV HatH_USER hath
ENV HatH_PATH "/home/$HatH_USER/client"
ENV HatH_ARCHIVE hath.zip

ENV JAVA /opt/jdk/bin/java
ENV JAVA_ARGS -jar $HATH
ENV HATH_JAR HentaiAtHome.jar

# Container Setup
RUN adduser -D "$HatH_USER" && \
    mkdir "$HatH_PATH" && \
    cd "$HatH_PATH" && \
    curl -fsSL "$HatH_DOWNLOAD_URL" -o "$HatH_ARCHIVE" && \
    echo -n ""$HatH_DOWNLOAD_SHA256"  "$HatH_ARCHIVE"" | sha256sum -c && \
    unzip "$HatH_ARCHIVE" && \
    rm "$HatH_ARCHIVE"

RUN mkdir -p "$HatH_PATH/data" "$HatH_PATH/tmp" "$HatH_PATH/downloaded"

COPY client/ "$HatH_PATH/"

RUN chmod -R 775 "$HatH_PATH"
WORKDIR "$HatH_PATH"

# Expose the port
EXPOSE 4284

VOLUME "$HatH_PATH/data" "$HatH_PATH/downloaded"

CMD nohup $JAVA $JAVA_ARGS $HATH_ARGS > /dev/null 2>&1 &