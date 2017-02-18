#!/bin/bash
#


declare -r VERSION=$(lsb_release -cs)
declare -r PUPPET_URL=https://apt.puppetlabs.com/puppetlabs-release-pc1-${VERSION}.deb
declare -r DOCKER_URL=https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_1.13.1-0~ubuntu-${VERSION}_amd64.deb


# Get the deb file, then install it
wget ${PUPPET_URL} -O /tmp/puppet.deb
dpkg -i /tmp/puppet.deb
apt-get update
apt-get install --assume-yes puppet-agent git curl libltdl7 libnih-dbus1 aufs-tools mountall cgroupfs-mount cgroup-lite

wget ${DOCKER_URL} -O /tmp/docker.deb
dpkg -i /tmp/docker.deb
apt-get update

curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# Enable puppet to run on startup & then run puppet agent
/opt/puppetlabs/puppet/bin/puppet resource service puppet ensure=running enable=true
/opt/puppetlabs/puppet/bin/puppet agent -t

exit 0
