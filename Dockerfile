FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# build image with the following command
# docker build --progress=plain -t "andreasferdinand/cnc-ca-server:latest" .

# run container with the following command
# docker run -it --rm -p 1234:1234 -e name="CnC-CA-Server by Andreas" -e ListenPort="1234" --name "cnc-ca-server" andreasferdinand/cnc-ca-server:latest
# docker run -d --rm -p 1234:1234 -e name="CnC-CA-Server by Andreas" -e ListenPort="1234" --name "cnc-ca-server" andreasferdinand/cnc-ca-server:latest

ARG CNC_CA_RELEASE
ARG REPOSITORY=Inq8/CAmod

LABEL build_version="1.0"
LABEL maintainer="AndreasFerdinand"

RUN \
    set -xe; \
    echo -e "\033[1;32m*** Start image build process for 'Command & Conquer - Combined Arms' ***\033[0m" && \
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
                    jq \
                    python3 && \
    APIURL="https://api.github.com/repos/${REPOSITORY}/releases/latest" && \
    if [ -z ${CNC_CA_RELEASE+x} ]; then \
        CNC_CA_RELEASE=$(curl --silent "${APIURL}" | jq '.tag_name' -r); \
    fi && \
    echo -e "\033[1;32m*** Building image for 'Command & Conquer - Combined Arms' release ${CNC_CA_RELEASE} ***\033[0m" && \
    SOURCE_URL=https://github.com/${REPOSITORY}/archive/refs/tags/${CNC_CA_RELEASE}.tar.gz && \
    useradd -d /home/cnc-ca -m -s /sbin/nologin cnc-ca && \
    curl -s -L -o /home/cnc-ca/cnc-ca.tar.gz ${SOURCE_URL} && \
    mkdir -p /home/cnc-ca/source && \
    tar -xzf /home/cnc-ca/cnc-ca.tar.gz -C /home/cnc-ca/source --strip-components=1 && \
    rm /home/cnc-ca/cnc-ca.tar.gz && \
    cd /home/cnc-ca/source && \
    make && \
    make version VERSION=${CNC_CA_RELEASE} && \
    apt-get purge -y --auto-remove \
                    curl \
                    make \
                    patch \
                    unzip \
                    wget \
                    jq && \
    apt-get clean && \
    mkdir -p /home/cnc-ca/.config/openra/Logs && \
    chown -R cnc-ca:cnc-ca /home/cnc-ca/.config/openra/ && \
    rm -rf /var/lib/apt/lists/*

USER cnc-ca
WORKDIR /home/cnc-ca/source

VOLUME /home/cnc-ca/.config/openra/Logs
VOLUME /home/cnc-ca/.config/openra/maps

CMD ["/home/cnc-ca/source/launch-dedicated.sh"]