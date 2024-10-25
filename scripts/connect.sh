#!/usr/bin/env bash

set -eu

. "$(dirname "$0")/var.sh"
if [ "$OS" = windows ]; then
	container=$container_windows
fi

if [ -z "${ARCH:-}" ]; then
	ARCH=$(uname -m)
	case $ARCH in
		x86_64) ARCH="amd64" ;;
		aarch64) ARCH="arm64" ;;
	esac
fi

echo "[INFO] Connecting to the container $container ($OS/$ARCH)" >&2

# Workaround to fix the symbolic link to aqua-proxy
# https://github.com/aquaproj/aqua-registry/pull/17896#issuecomment-1837703289
docker exec "$container" env AQUA_GOOS="$OS" AQUA_GOARCH="$ARCH" aqua i -l

docker exec -ti "$container" env AQUA_GOOS="$OS" AQUA_GOARCH="$ARCH" bash
