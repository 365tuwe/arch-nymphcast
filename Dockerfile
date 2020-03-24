FROM archlinux:latest

# Docker Image for building nymphcast server from
# https://aur.archlinux.org/packages/nymphcast-server-git/
#
# See https://github.com/MayaPosch/NymphCast

### Install requirements for building an aur package with makepkg
RUN pacman -Syu --noconfirm && \
    pacman -S --needed --noconfirm base-devel && \
    pacman -S --needed --noconfirm git && \
    rm -rf /var/cache/pacman/pkg/*.pkg

### Build dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --needed --noconfirm \
        ffmpeg \
        poco \
        sdl2_image \
    && \
    rm -rf /var/cache/pacman/pkg/*.pkg

### NymphRPC
RUN cd tmp && \
    git clone https://aur.archlinux.org/nymphrpc-git.git && \
    chown -R nobody: nymphrpc-git && \
    cd nymphrpc-git && \
    sudo -u nobody makepkg && \
    pacman -U --noconfirm /tmp/nymphrpc-git/*.pkg.tar.xz && \
    rm -rf /tmp/nymphrpc-git

### Nymphcast Server
RUN cd tmp && \
    git clone https://aur.archlinux.org/nymphcast-server-git.git && \
    chown -R nobody: nymphcast-server-git && \
    cd nymphcast-server-git && \
    sudo -u nobody makepkg -f && \
    pacman -U --noconfirm /tmp/nymphcast-server-git/*.pkg.tar.xz && \
    rm -rf /tmp/nymphcast-server-git

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
