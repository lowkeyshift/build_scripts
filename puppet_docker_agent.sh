#!/bin/bash

## This script runs after the OS has been setup, and installs puppet.

## Get our Ubuntu version, and figure out what package to download
VERSION=$(lsb_release -cs)
PUPPET_URL=https://apt.puppetlabs.com/puppetlabs-release-pc1-${VERSION}.deb
DOCKER_URL=https://apt.dockerproject.org/repo/pool/main/d/docker-engine/docker-engine_1.13.1-0~ubuntu-${VERSION}_amd64.deb


# Get the deb file for our version, then install it
wget ${PUPPET_URL} -O /tmp/puppet.deb
dpkg -i /tmp/puppet.deb
apt-get update
apt-get install --assume-yes puppet-agent git curl libltdl7 libnih-dbus1 aufs-tools mountall cgroupfs-mount cgroup-lite

wget ${DOCKER_URL} -O /tmp/docker.deb
dpkg -i /tmp/docker.deb
apt-get update

curl -L "https://github.com/docker/compose/releases/download/1.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# Enable puppet to run on startup 
/opt/puppetlabs/puppet/bin/puppet resource service puppet ensure=running enable=true
/opt/puppetlabs/puppet/bin/puppet agent -t

## Always exit 0, or the installer will hang, prompting you with "XYZ failed [continue]"
exit 0
