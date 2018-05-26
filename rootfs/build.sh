#!/bin/sh

set -euo pipefail

pacman -Syu --needed --noconfirm base-devel git

useradd -m builder
echo 'builder ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/builder

for PKG in package-query yaourt
do
    SRC_URL="https://aur.archlinux.org/${PKG}.git"
    SRC_DIR="/home/builder/{$PKG}"

    sudo -u builder git clone "${SRC_URL}" "${SRC_DIR}"
    (cd "${SRC_DIR}" && sudo -u builder makepkg -is --noconfirm)
    rm -rf "${SRC_DIR}"
done

cat << EOF >> /etc/makepkg.conf
PKGDEST=/pkg
SRCDEST=/src
SRCPKGDEST=/srcpkg
EOF

cat << EOF >> /etc/yaourtrc
EXPORT=1
EOF

mkdir -m 777 /pkg /src /srcpkg
