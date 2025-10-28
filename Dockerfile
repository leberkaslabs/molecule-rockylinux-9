FROM rockylinux/rockylinux:9

LABEL org.opencontainers.image.authors="LeberkasLabs"
LABEL org.opencontainers.image.description="Rocky Linux 9 Container Image for Ansible Molecule"
LABEL org.opencontainers.image.source="https://github.com/leberkaslabs/molecule-rockylinux-9"

# Install required packages
RUN dnf -qy update \
    && dnf -qy install \
        dnf-plugins-core \
        epel-release \
        hostname \
        initscripts \
        iproute \
        libyaml \
        python3 \
        python3-pip \
        python3-pyyaml \
        rpm \
        sudo \
        tzdata \
        which \
    && dnf clean all

# Clean up unnecessary systemd services for container environment
# https://hub.docker.com/r/rockylinux/rockylinux#dockerfile-for-systemd-base-image
RUN cd /lib/systemd/system/sysinit.target.wants/; \
    for i in * ; do [ "$i" = systemd-tmpfiles-setup.service ] || rm -f "$i"; done; \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/' /etc/sudoers

VOLUME ["/sys/fs/cgroup"]

CMD ["/usr/sbin/init"]
