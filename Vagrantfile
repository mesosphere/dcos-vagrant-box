# -*- mode: ruby -*-
# vi: set ft=ruby :

$dcos_box = ENV.fetch("DCOS_BOX", "mesosphere/dcos-centos-virtualbox")
$dcos_box_url = ENV.fetch("DCOS_BOX_URL", "http://downloads.dcos.io/dcos-vagrant/metadata.json")
$dcos_box_version = ENV.fetch("DCOS_BOX_VERSION", nil)

Vagrant.configure(2) do |config|
  # configure vagrant-vbguest plugin
  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = true
  end

  config.vm.define "dcos-centos-virtualbox" do |vm_cfg|
    vm_cfg.vm.box = $dcos_box
    vm_cfg.vm.box_url = $dcos_box_url
    vm_cfg.vm.box_version = $dcos_box_version

    vm_cfg.vm.provider "virtualbox" do |v|
      v.name = "dcos-centos-virtualbox"
      v.cpus = 2
      v.memory = 2048
      v.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    end
  end
end
