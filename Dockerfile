FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# build image with the following command
# docker build --progress=plain -t "andreasferdinand/cnc-ca-server:1.04" .

# run container with the following command
# docker run -it --rm -p 1234:1234 -e name="CnC-CA-Server by Andreas" -e ListenPort="1234" --name "cnc-ca-server" andreasferdinand/cnc-ca-server:1.04
# docker run -d --rm -p 1234:1234 -e name="CnC-CA-Server by Andreas" -e ListenPort="1234" --name "cnc-ca-server" andreasferdinand/cnc-ca-server:1.04

ARG CNC_CA_RELEASE=1.04

LABEL build_version="1.0"
LABEL maintainer="AndreasFerdinand"

ARG SOURCE_URL=https://github.com/Inq8/CAmod/archive/refs/tags/${CNC_CA_RELEASE}.tar.gz

RUN \
    set -xe; \
    echo "*** Building image for Command & Conquer Combined Arms ${CNC_CA_RELEASE} ***" && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
                    ca-certificates \
                    curl \
                    liblua5.1 \
                    libsdl2-2.0-0 \
                    libopenal1 \
                    make \
                    patch \
                    unzip \
                    xdg-utils \
                    zenity \
                    wget \
                    python3 && \
    useradd -d /home/cnc-ca -m -s /sbin/nologin cnc-ca && \
    curl -s -L -o /home/cnc-ca/cnc-ca.tar.gz  ${SOURCE_URL} && \
    mkdir -p /home/cnc-ca/source && \
    tar -xzf /home/cnc-ca/cnc-ca.tar.gz -C /home/cnc-ca/source --strip-components=1 && \
    rm /home/cnc-ca/cnc-ca.tar.gz && \
    cd /home/cnc-ca/source && \
    make && \
    make version VERSION=${CNC_CA_RELEASE} && \
    apt-get clean && \
    mkdir -p /home/cnc-ca/.config/openra/Logs && \
    chown -R cnc-ca:cnc-ca /home/cnc-ca/.config/openra/ && \
    rm -rf /var/lib/apt/lists/*

USER cnc-ca
WORKDIR /home/cnc-ca/source

VOLUME /home/cnc-ca/.config/openra/Logs
VOLUME /home/cnc-ca/.config/openra/maps

CMD ["/home/cnc-ca/source/launch-dedicated.sh"]