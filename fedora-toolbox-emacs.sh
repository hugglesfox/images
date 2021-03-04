#!/usr/bin/env bash
set -euo pipefail

release=${1:-latest}

packages="\
    ShellCheck \
    aspell \
    aspell-en \
    automake \
    emacs \
    fd-find \
    fira-code-fonts \
    gcc \
    gcc-c++ \
    jq \
    kernel-devel \
    make \
    pandoc \
    pipenv \
    python3-black \
    python3-isort \
    python3-pyflakes \
    python3-pytest \
    ripgrep"

container=$(buildah from fedora-toolbox:$release)
buildah run $container -- dnf -y install $packages
buildah run $container -- dnf clean all

# Use host firefox for markdown previewing
buildah run $container -- bash -c 'cat <<EOF > /usr/bin/firefox
#!/bin/bash
flatpak-spawn --host firefox \$@
EOF'
buildah run $container -- chmod +x /usr/bin/firefox

buildah commit $container fedora-toolbox-emacs

