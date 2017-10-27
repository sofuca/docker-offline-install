#!/usr/bin/env bash

# Update apt, install apt secure transport and cerificates, and apt-mirror 
apt-get update
apt-get -y install apt-transport-https ca-certificates apt-mirror

# Get dependencies

wget http://mirrors.kernel.org/ubuntu/pool/universe/a/aufs-tools/aufs-tools_3.2+20130722-1.1ubuntu1_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/universe/c/cgroupfs-mount/cgroupfs-mount_1.2_all.deb
wget http://mirrors.kernel.org/ubuntu/pool/main/libt/libtool/libltdl7_2.4.6-0.1_amd64.deb

# Tar dependencies up

tar cvf dependencies.tar *.deb

# Get Docker's public key and add it to apt for package signiture verification
apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Add Docker's apt repo to apt-mirror's mirror list
echo deb https://apt.dockerproject.org/repo ubuntu-xenial main > /etc/apt/mirror.list

# Run apt-mirror to download Docker repo to current directory
apt-mirror

# Save Docker's public key to the mirror directory
apt-key export 58118E89F3A912897C070ADBF76221572C52609D > /var/spool/apt-mirror/mirror/apt.dockerproject.org/docker.key

# Compress the mirror dir to an archive file in the home directory
tar -cvzf docker_mirror.tar.gz -C /var/spool/apt-mirror/mirror apt.dockerproject.org
