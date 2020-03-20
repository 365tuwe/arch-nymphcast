# NymphCast server docker container based on Arch Linux

:warning: Untested. Use at your own risk

Sources:

* https://github.com/MayaPosch/NymphCast
* https://aur.archlinux.org/packages/nymphrpc-git/
* https://aur.archlinux.org/packages/nymphcast-server-git/

## Build

    docker build -t 365tuwe/arch-nymphcast .

## Run

    docker run --name nymphcast_server 365tuwe/arch-nymphcast

## Stop

    docker stop nymphcast_server

## Todo

* Provide custom directory for configuration files and apps
