FROM quay.io/podman/stable
ARG ansible_version=2.16
ADD containers.conf /etc/containers/containers.conf
RUN dnf install -y python3 pip git python3-virtualenv
RUN virtualenv -p "python3" /virtualenv/$ansible_version/ && mkdir -p /virtualenv/$ansible_version/
RUN source /virtualenv/$ansible_version/bin/activate && pip install ansible-core==$ansible_version molecule==5.0.1 molecule-plugins==23.4.1 molecule-podman==2.0.3 ansible-lint==6.16.2 molecule-docker==2.1.0 &&  molecule --version
