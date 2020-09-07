# -*- mode: ruby -*-
# vi: set ft=ruby :

#creates an UBUNTU 18.04 server
#all required tools as used by the install.cn.app.sh script are preinstalled
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  config.vm.network "forwarded_port", guest: 80, host: 80
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  config.vm.provision "shell", inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

    apt-get update
    apt-get install -y apt-transport-https ca-certificates software-properties-common

    echo installing golang 1-2min...
    cd /usr/local/
    curl -OLs --output /dev/null https://golang.org/dl/go1.15.1.linux-amd64.tar.gz
    tar -C /usr/local -xzf go1.15.1.linux-amd64.tar.gz
    echo "PATH=$PATH:/usr/local/go/bin" >> /home/vagrant/.bashrc

    echo installing jq...
    apt-get install -y jq

    echo installing nodejs...
    apt-get install -y nodejs

    echo installing yarn...
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    apt-get update
    apt-get install -y yarn

    echo installing docker...
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
    apt-get update
    apt-get install -y docker-ce
    usermod -aG docker vagrant

    echo ==============
    echo versions - $(date)
    echo go: $(/usr/local/go/bin/go version)
    echo jq: $(jq --version)
    echo node: $(node -v)
    echo yarn: $(yarn --version)
    echo docker: $(docker -v)
  SHELL

end