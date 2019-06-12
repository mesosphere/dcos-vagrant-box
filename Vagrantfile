# -*- mode: ruby -*-
# vi: set ft=ruby :

$dcos_box = ENV.fetch("DCOS_BOX", "mesosphere/dcos-centos-virtualbox")
$dcos_box_url = ENV.fetch("DCOS_BOX_URL", "http://downloads.dcos.io/dcos-vagrant/metadata.json")
$dcos_box_version = ENV.fetch("DCOS_BOX_VERSION", nil)

$cpus = 2
$memory = 2048

Vagrant.configure(2) do |config|
  # configure vagrant-vbguest plugin
  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = true
  end

  config.vm.hostname = 'dcos-centos'
  config.vm.box = $dcos_box
  config.vm.box_url = $dcos_box_url
  config.vm.box_version = $dcos_box_version

  config.vm.provider "virtualbox" do |vb|
    vb.name = "dcos-centos-virtualbox"
    vb.cpus = $cpus
    vb.memory = $memory
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    vb.linked_clone = true
  end
  config.vm.provider "vmware_fusion" do |vmware|
    vmware.vmx['cpus'] = $cpus
    vmware.vmx['memsize'] = $memory
    vmware.vmx['displayName'] = "dcos-centos-vmware"
    vmware.linked_clone = true
  end

end
