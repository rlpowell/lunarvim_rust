#!/bin/bash

# Error trapping from https://gist.github.com/oldratlee/902ad9a398affca37bfcfab64612e7d1
__error_trapper() {
  local parent_lineno="$1"
  local code="$2"
  local commands="$3"
  echo "error exit status $code, at file $0 on or near line $parent_lineno: $commands"
}
trap '__error_trapper "${LINENO}/${BASH_LINENO}" "$?" "$BASH_COMMAND"' ERR

set -euE -o pipefail

podman build -t lunarvim_rust .

mkdir -p ~/.local/rust_docker_cargo

podman kill lunarvim_rust || true
podman rm lunarvim_rust || true

# See https://github.com/xd009642/tarpaulin/issues/1087 for the seccomp thing
podman run --name lunarvim_rust --security-opt seccomp=seccomp.json -w /root/src \
  -v ~/src:/root/src -v ~/.local/rust_docker_cargo:/root/.cargo \
  -v ~/config/dotfiles/lunarvim:/root/.config/lvim  -v ~/config/dotfiles/bashrc:/root/.bashrc \
  -v ~/config/dotfiles/bothrc:/root/.bothrc \
  -it lunarvim_rust bash
