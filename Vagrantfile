# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git"
  config.vm.provision "shell", path: "scripts/vagrant_setup.sh"
  
  #set everything up, but don't run highstate yet.
  #allows us to get spm installed
  config.vm.provision :salt do |salt|
    salt.minion_config = 'minion.conf'
    salt.bootstrap_options = '-U -Z'
    salt.masterless = true
    salt.run_highstate = false
    salt.colorize = true
    salt.verbose = true
  end

  config.vm.provision "shell", path: "scripts/spm.sh"

  #run highstate this time (with installed packages)
  config.vm.provision :salt do |salt|
    salt.minion_config = 'minion.conf'
    salt.bootstrap_options = '-U -Z'
    salt.masterless = true
    salt.run_highstate = true
    salt.colorize = true
    salt.verbose = true
  end
end
