#!/bin/bash
set -eou pipefail

pod_id=$(podman run --rm --name pop --privileged -u jenkins  -d  pop /bin/bash -c "sleep infinity")

echo "Container created (${pod_id}), try to run podman images inside it!"
podman exec -ti "${pod_id}" /bin/bash
