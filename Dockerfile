FROM registry.fedoraproject.org/fedora
VOLUME ["/etc/pki"]
RUN dnf install -y ansible-core gcc python3-pip python3-devel python3-lxml libxml2-devel \
                   libxslt-devel openssl-devel python3-libselinux vim-enhanced git ncurses \
                   ansible-lint jq procps-ng sudo podman && dnf clean all && dnf update -y
RUN pip --version
RUN groupadd -g 1000 jenkins && \
    groupadd sudo && \
    useradd -ms /bin/bash -d /var/jenkins_home/ -u 1000 -g jenkins jenkins && \
    usermod -aG sudo jenkins && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
#RUN pip-3.9 install molecule molecule-docker molecule-podman && \
#    pip-3.9 install --upgrade pip setuptools
RUN pip install molecule molecule-docker molecule-podman && \
    pip install --upgrade pip setuptools
RUN usermod -aG root jenkins
RUN chown 0:0 /etc/passwd
RUN chown 0:0 /etc/group
RUN chmod g=u /etc/passwd /etc/group
RUN setcap cap_setuid+ep /usr/bin/newuidmap
RUN setcap cap_setgid+ep /usr/bin/newgidmap
RUN touch /etc/subgid /etc/subuid
RUN chown 0:0 /etc/subgid
RUN chown 0:0 /etc/subuid
RUN chmod -R g=u /etc/subuid /etc/subgid
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
