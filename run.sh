#!/bin/bash
readonly PODMAN_CONTAINER_NAME=${1:-"$(basename $(pwd))"}
readonly PODMAN_IMAGE=${PODMAN_IMAGE:-'localhost/pop'}
readonly PATH_TO_WORKDIR=${PATH_TO_WORKDIR:-'/work'}
readonly PODMAN

podman run  -v "$(pwd):${PATH_TO_WORKDIR}:rw" \
            --workdir "${PATH_TO_WORKDIR}" \
            --rm --name "${PODMAN_CONTAINER_NAME}" \
            -it --privileged \
            "${PODMAN_IMAGE}" /bin/bash
