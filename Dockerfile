FROM archlinux:latest AS builder

# Docker Image for building nymphcast server from
# https://aur.archlinux.org/packages/nymphcast-server-git/
#
# See https://github.com/MayaPosch/NymphCast

WORKDIR /nymphcast

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
RUN git clone https://aur.archlinux.org/nymphrpc-git.git && \
    chown -R nobody: nymphrpc-git && \
    cd nymphrpc-git && \
    sudo -u nobody makepkg && \
    pacman -U --noconfirm *.pkg.tar.xz

### Nymphcast Server
RUN git clone https://aur.archlinux.org/nymphcast-server-git.git && \
    chown -R nobody: nymphcast-server-git && \
    cd nymphcast-server-git && \
    sudo -u nobody makepkg

FROM archlinux:latest

WORKDIR /root/

RUN pacman -Syu --noconfirm && \
    pacman -S --needed --noconfirm \
        ffmpeg \
        sdl2_image \
    && \
    rm -rf /var/cache/pacman/pkg/*.pkg

COPY --from=builder /nymphcast/nymphcast-server-git/*.pkg.tar.xz .
COPY --from=builder /nymphcast/nymphrpc-git/*.pkg.tar.xz .

RUN pacman -U --noconfirm *.pkg.tar.xz

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
