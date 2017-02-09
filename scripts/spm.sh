#!/bin/bash
if [ "$(ls /vagrant)" ]
then
    SRCDIR=/vagrant
else
    SRCDIR=/home/vagrant/sync
fi

#clean the build area
if [ -d /srv/spm_build ]; then
    sudo rm -rf /srv/spm_build
fi
#clean the installation cache
if [ -d /var/cache/salt/spm/ ]; then
sudo rm -rf /var/cache/salt/spm
fi
#clean the installed package area
if [ -d /srv/spm ]; then
sudo rm -rf /srv/spm
fi

# set up remote repo
sudo mkdir -p /etc/salt/spm.repos.d
echo "\
remote_repo:
  url: file:///srv/spm_remote_repo" | sudo tee /etc/salt/spm.repos.d/spm_remote.repo
if [ -d /srv/spm_remote_repo ]; then
sudo rm -rf /srv/spm_remote_repo
fi
mkdir /srv/spm_remote_repo

#set up local repo
echo "\
local_repo:
  url: file:///srv/spm_local_repo" | sudo tee /etc/salt/spm.repos.d/spm_local.repo
if [ -d /srv/spm_local_repo ]; then
sudo rm -rf /srv/spm_local_repo
fi
mkdir /srv/spm_local_repo

#build this package
sudo spm build $SRCDIR

#copy the package to each repo
cp /srv/spm_build/*.spm /srv/spm_remote_repo
cp /srv/spm_build/*.spm /srv/spm_local_repo

#create each repo's metadata
sudo spm create_repo /srv/spm_remote_repo
sudo spm create_repo /srv/spm_local_repo

#try installing this package
sudo spm update_repo
sudo spm install spm-multi-repo
