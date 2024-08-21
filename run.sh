#!/bin/bash
readonly PODMAN_CONTAINER_NAME=${1:-'pop'}
readonly PODMAN_IMAGE=${PODMAN_IMAGE:-'pop'}

podman run --rm --name "${PODMAN_CONTAINER_NAME}" -it --privileged "${PODMAN_IMAGE}" /bin/bash
