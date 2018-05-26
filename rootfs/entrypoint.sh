#!/bin/sh

set -euo pipefail

function ensure_group() {
    if ! GROUPNAME="$(getent group "${1}" | grep -o '^[^:]*')"
    then
        GROUPNAME=another-builder
        groupadd -g "${PGID}" "${GROUPNAME}" >&2
    fi

    echo "${GROUPNAME}"
}

function ensure_user() {
    if ! USERNAME="$(getent passwd "${1}" | grep -o '^[^:]*')"
    then
        USERNAME=another-builder
        useradd -u "${1}" -g "${2}" "${USERNAME}" >&2
    fi

    echo "${USERNAME}"
}

PUID="${PUID:-$(id -u builder)}"
PGID="${PGID:-$(id -g builder)}"

YAOURT_GROUP="$(ensure_group "${PGID}")"
YAOURT_USER="$(ensure_user "${PUID}" "${PGID}")"

echo "${YAOURT_USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${YAOURT_USER}"

pacman -Syu --noconfirm
sudo -u "${YAOURT_USER}" -g "${YAOURT_GROUP}" yaourt "${@}"
