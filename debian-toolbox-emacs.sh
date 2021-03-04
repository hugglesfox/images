#!/usr/bin/env bash
set -euo pipefail

release=${1:-sid}
distro=${2:-debian}

packages="\
    aspell \
    aspell-en \
    black \
    build-essential \
    emacs \
    fd-find \
    fonts-firacode \
    jq \
    node-js-beautify \
    npm \
    pandoc \
    pipenv \
    python3-isort \
    python3-nose \
    python3-pyflakes \
    python3-pytest \
    ripgrep \
    tmux \
    shellcheck \
    unzip"

container=$(buildah from $distro-toolbox:$release)

buildah run $container -- apt-get update
buildah run $container -- apt-get install -y $packages

# Use host firefox for markdown previewing
buildah run $container -- bash -c 'cat <<EOF > /usr/bin/firefox
#!/bin/bash
flatpak-spawn --host firefox \$@
EOF'

buildah run $container -- chmod +x /usr/bin/firefox

buildah commit $container $distro-toolbox-emacs:$release

