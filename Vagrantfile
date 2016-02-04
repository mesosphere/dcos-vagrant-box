# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant-Cloud
# export DCOS_BOX=karlkfi/dcos-centos-virtualbox
# export DCOS_BOX_URL=https://atlas.hashicorp.com/karlkfi/dcos-centos-virtualbox

# Local Repo
# export DCOS_BOX_URL=file://~/workspace/dcos-vagrant/build/metadata.json

# Local Box
# vagrant box add mesosphere/dcos-centos-virtualbox file://~/workspace/dcos-vagrant/build/dcos-centos-virtualbox.box
# export DCOS_BOX_VERSION=0

DCOS_BOX = ENV.fetch("DCOS_BOX", "mesosphere/dcos-centos-virtualbox")
DCOS_BOX_URL = ENV.fetch("DCOS_BOX_URL", "https://s3-us-west-1.amazonaws.com/dcos-vagrant/metadata.json")
DCOS_BOX_VERSION = ENV.fetch("DCOS_BOX_VERSION", nil)

Vagrant.configure(2) do |config|
  config.vm.define "dcos-centos-virtualbox" do |vm_cfg|
    vm_cfg.vm.box = DCOS_BOX
    vm_cfg.vm.box_url = DCOS_BOX_URL
    vm_cfg.vm.box_version = DCOS_BOX_VERSION

    vm_cfg.vm.provider "virtualbox" do |v|
      v.name = "dcos-centos-virtualbox"
      v.cpus = 2
      v.memory = 2048
    end
  end
end
