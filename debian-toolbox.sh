#!/usr/bin/env bash
set -euo pipefail

release=${1:-sid}
distro=${2:-debian}

packages="\
    bash-completion \
    curl \
    flatpak-xdg-utils \
    git \
    gnupg \
    less \
    libcap2-bin \
    libnss-myhostname \
    locales \
    man-db \
    sudo \
    unzip \
    vim \
    wget"

container=$(buildah from $distro:$release)

buildah run $container -- apt-get update
buildah run $container -- sh -c "DEBIAN_FRONTEND=\"noninteractive\" apt-get install -y $packages"

# Generate locales for en_AU.UTF-8
buildah run $container -- sed -i '/en_AU.UTF-8/s/^#//g' /etc/locale.gen
buildah run $container -- locale-gen

buildah commit $container $distro-toolbox:$release

