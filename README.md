# Yaourt

Dockerfile for Yaourt, an package manager for Arch Linux with AUR 
support.

## Usage

Same as `yaourt` command line options. The package archive file will be 
saved in `/pkg` directory.

    docker run --rm -v $(pwd)/pkg:/pkg t13a/yaourt -S --noconfirm PACKAGE

Also can specify process UID/GID, archive source, build multiple 
packages.

    docker run --rm \
    -e PUID=1001 \
    -e PGID=1002 \
    -v $(pwd)/pkg:/pkg \
    -v $(pwd)/src:/src \
    -v $(pwd)/srcpkg:/srcpkg \
    t13a/yaourt \
    -S --noconfirm \
    PACKAGE...
