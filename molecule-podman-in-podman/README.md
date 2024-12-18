## podman on podman on rhel

This container is based on the python 3.11 avriant of ubi8 and id meant to run other podman containers inside it (specifically, molecule containers).

To build:

    podman build -f Containerfile --build-arg ANSIBLE_VERSION=2.15.0 -t <image_name>

The outer container is proviliged and needs to run as root with:

    podman run --name=runner --replace --security-opt label=disable --security-opt seccomp=unconfined --device /dev/fuse:rw -v /var/lib/runner:/var/lib/containers:Z --privileged -ti --rm <image_name>

Each outer container needs its own `/var/lib/runner` (world-writable) directory on the host to contain overlays and images.

In the outer container `/var/lib/shared` contains the files for the inner containers.

When inside the outer container, as the user `runner`, you can directly run `molecule`

Inner containers will only be visible in the outer container that created them.
Outer containers are visible to the host, while inner containers are not.
