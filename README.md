# Command & Conquer - Combined Arms - Docker Server
This image contains the components for running a dedicated 'Command & Conquer - Combined Arms' docker server.

> [!IMPORTANT]  
> All instructions regarding the `docker` command assume, that docker can be executed without `sudo`. So either set up [docker for non-root users](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) or use `sudo`.

## Disclaimer
> [!WARNING]  
> This image is under development, only use in save environments!

## About the game
[Command & Conquer - Combined Arms](https://www.moddb.com/mods/command-conquer-combined-arms) ([Source](https://github.com/Inq8/CAmod)) is a free game based on [OpenRA](https://www.openra.net/).

## Related projects
* [Dockerfile for an OpenRA dedicated server](https://github.com/rmoriz/openra-dockerfile)

## tl;dr
```bash
git clone https://github.com/AndreasFerdinand/CombinedArms-DockerServer.git
cd CombinedArms-DockerServer
docker build --progress=plain -t "andreasferdinand/cnc-ca-server:1.04" .
docker run -d --rm -p 1234:1234 \
  -e name="CnC-CA-Server by AndreasFerdinand" \
  -e ListenPort="1234" \
  -e Password="quertzui" \
  --name "cnc-ca-server" \
  andreasferdinand/cnc-ca-server:1.04
```

## Detailed building instructions
1. Install Docker

    For details regarding the installation see https://docs.docker.com/engine/install/.

2. Download `Dockerfile`

    Either download the file with your browser or use `curl` to get it on your computer.

    ```bash
    curl https://raw.githubusercontent.com/AndreasFerdinand/CombinedArms-DockerServer/refs/heads/main/Dockerfile -o Dockerfile
    ```

3. Build the image

    To specify the 'Command & Conquer - Combined Arms' release version, it must be set using `--build-arg` argument. If not set, version `1.04` is used.

    * `--build-arg CNC_CA_RELEASE=1.04`

    If neccessary add the above mentioned arguments to the build command (please consider the `.` at the end of the line):

    ```bash
    docker build --progress=plain -t "andreasferdinand/cnc-ca-server:1.04" .
    ```

4. Run the container

    ```bash
    docker run -d --rm -p 1234:1234 \
    -e name="CnC-CA-Server by AndreasFerdinand" \
    -e ListenPort="1234" \
    -e Password="quertzui" \
    --name "cnc-ca-server" \
    andreasferdinand/cnc-ca-server:1.04
    ```

    * At least change the password if server should't used by unaothorized users
    * Additional environment variables to configure the server can be found in the file [launch-dedicated.sh](https://github.com/Inq8/CAmod/blob/master/launch-dedicated.sh).

## Some useful things about docker

### Open shell in container
```bash
sudo docker exec -it <conteinerid> /bin/bash
```

### Remove container
```bash
sudo docker container rm <conteinerid>
```

### Remove orphaned volumes
The container uses 3 volumes. If the container and the volumes aren't needed more, **all** (not only volumes related to the cloud connctor container) orphaned volumes can be deleted using the following command:

```bash
sudo docker volume prune
```

To view orphaned volumes use:

```bash
sudo docker volume ls -f "dangling=true"
```

## FAQ
tbd

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing
You are welcome to send feedback, improvements, pull requests or bug reports.

## Ressources
* [OpenRA Wiki: Dedicated Server](https://github.com/OpenRA/OpenRA/wiki/Dedicated-Server)