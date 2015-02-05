# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty64"

  # Set all boxes to have 2GB of ram
  # and 2 CPUS
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.network "forwarded_port", guest: 80, host: 8081

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "init.pp"
    puppet.module_path = "puppet/modules"
    puppet.hiera_config_path = "hiera.yaml"
    puppet.working_directory = "/tmp/vagrant-puppet"
  end


  # See http://stackoverflow.com/questions/11955525
  Vagrant::Config.run do |config|
    config.ssh.private_key_path = "~/.ssh/id_rsa"
    config.ssh.forward_agent = true
  end

  # See https://www.danpurdy.co.uk/web-development/osx-yosemite-port-forwarding-for-vagrant/
  # for Mac OS Yosemite 10.10
  #config.trigger.after [:provision, :up, :reload] do
  #  system('echo "
  #      rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 8080 -> 127.0.0.1 port 8082
  #      rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 443 -> 127.0.0.1 port 4443
  #" | sudo pfctl -ef - > /dev/null 2>&1; echo "==> Fowarding Ports: 8080 -> 8082 & Enabling pf"')
  #end

  #config.trigger.after [:halt, :destroy] do
  #  system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling pf'")
  #end

end
