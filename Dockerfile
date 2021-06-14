FROM debian:stable-slim
LABEL maintainer="Nick Voorham - <n.voorham@picturae.com>"
WORKDIR /supertuxkart

EXPOSE 2759
EXPOSE 2757

# install dependencies
RUN set -x \
        && apt-get update \
        && echo 'downloading dependencies' \
        && apt-get install -y \
                git \
                subversion \
                sudo

# install supertuxkart source
RUN set -x \
       && echo 'downloading supertuxkart source' \
       && git clone https://github.com/supertuxkart/stk-code stk-code \
       && svn co https://svn.code.sf.net/p/supertuxkart/code/stk-assets stk-assets
# COPY stk-code ./stk-code
# COPY stk-assets ./stk-assets

# install dependencies to build supertuxkart from source
RUN set -x \
        && echo 'downloading dependencies for build' \
        && sudo apt-get install build-essential -y \
        && sudo apt-get install cmake -y \
        && sudo apt-get install libbluetooth-dev -y \
        && sudo apt-get install libsdl2-dev -y \
        && sudo apt-get install libcurl4-openssl-dev -y \
        && sudo apt-get install libenet-dev -y \
        && sudo apt-get install libfreetype6-dev -y \
        && sudo apt-get install libharfbuzz-dev -y \
        && sudo apt-get install libjpeg-dev -y \
        && sudo apt-get install libogg-dev -y \
        && sudo apt-get install libopenal-dev -y \
        && sudo apt-get install libpng-dev -y \
        && sudo apt-get install libssl-dev -y \
        && sudo apt-get install libvorbis-dev -y \
        && sudo apt-get install nettle-dev -y \
        && sudo apt-get install pkg-config -y \
        && sudo apt-get install zlib1g-dev -y

# compile the supertuxkart server
RUN set -x \
        && echo 'compile supertuxkart' \
        && cd stk-code \
        && mkdir cmake_build \
        && cd cmake_build \
        && cmake .. -DSERVER_ONLY=ON -DBUILD_RECORDER=off \
        && make -j$(nproc) \
        && cd bin

# copy config
COPY config.xml ./stk-code/cmake_build/bin/config.xml

WORKDIR /supertuxkart/stk-code/cmake_build/bin
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]

RUN set -x \
        && ./supertuxkart --init-user --login=nickflik0934 --password=iamnickflik0934 \
        && echo "Finished building, please run the docker container to start the stk server"


