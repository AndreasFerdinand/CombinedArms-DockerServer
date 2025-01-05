#!/bin/sh
set -e

CNC_CA_RELEASE=latest
HOSTPORT=1234

trap 'docker rm -f cnc-ca-server' SIGINT

command -v curl >/dev/null 2>&1 || { echo >&2 "curl is required to run the tldr script"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo >&2 "docker is required to run the tldr script"; exit 1; }

if command -v pwgen >/dev/null 2>&1; then
    PASSWORD=$(pwgen -cA 8)
else
    command -v shuf >/dev/null 2>&1 || { echo >&2 "pwgen or shuf is required to run the tldr script"; exit 1; }
    PASSWORD=$(shuf -n1 /usr/share/dict/words)
fi

mkdir -p CombinedArms-DockerServer
cd CombinedArms-DockerServer

curl https://raw.githubusercontent.com/AndreasFerdinand/CombinedArms-DockerServer/refs/heads/main/Dockerfile -o Dockerfile

docker build --progress=plain -t "andreasferdinand/cnc-ca-server:${CNC_CA_RELEASE}" .

LOCAL_IP_ADDRESS=$(ip route get 1 | awk '{print $7;exit}')
PUBLIC_IP_ADDRESS=$(curl -s ifconfig.me)
PUBLIC_HOSTNAME=$(curl -s ipinfo.io/hostname)

echo -e "\033[1;32mDocker image successfully built. Starting server...\033[0m"
echo ""
echo -e "\033[1;32mConnection details:\033[0m"
echo -e "\033[1;32m\tLocal network connection\033[0m"
echo -e "\033[1;32m\t\tIP-Address: \033[0m${LOCAL_IP_ADDRESS}"
echo -e "\033[1;32m\t\tCan be used to access the server from local network.\033[0m"
echo ""
echo -e "\033[1;32m\tPublic internet connection\033[0m"
echo -e "\033[1;32m\t\tIP-Address: \033[0m${PUBLIC_IP_ADDRESS}"
echo -e "\033[1;32m\t\tHostname:  \033[0m${PUBLIC_HOSTNAME}"
echo -e "\033[1;32m\t\tCan be used to access the server from internet, if external requests are forwarded by your router.\033[0m"
echo -e "\033[1;32m\t\tCheck subsequent messages if server is reachable.\033[0m"
echo ""
echo -e "\033[1;32mConnect to Command and Conquer: Combined Arms server can be accessed on port \033[0m${HOSTPORT}\033[1;32m with password: \033[0m${PASSWORD}"
echo ""
echo -e "\033[1;32mStop and remove the container with CTRL+C\033[0m"

docker run -t --rm -p "${HOSTPORT}":1234 \
  -e name="CnC-CA-Server by AndreasFerdinand" \
  -e ListenPort="1234" \
  -e Password="${PASSWORD}" \
  -e EnableSingleplayer="true" \
  --name "cnc-ca-server" \
  andreasferdinand/cnc-ca-server:${CNC_CA_RELEASE}