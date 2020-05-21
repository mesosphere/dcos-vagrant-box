# DC/OS Vagrant Box

Vagrant box builder for use by tools such as [miniDC/OS](https://minidcos.readthedocs.io/en/latest/).  It makes use of [Packer](https://www.packer.io/) to automate the build process.

The box produced by this builder **does not include DC/OS**, just its dependencies.

Pre-provisioning this box front-loads internet access requirements, flakiness, and slowness resulting from third party package managemers and installers. This makes DC/OS installation faster and more reliable at the cost of potentially having slightly outdated dependencies.

## Provisioning Summary

- CentOS 7 (2003) ([kickstart file](http/ks.cfg))
- Ansible (for provisioning)
  - Python 2.7+
  - Pip 19.2+
  - Ansible 2.8+
- CentOS
  - Disable kdump (reduce resource consumption for smaller VMs)
  - Configure SSH daemon (disable DNS and API authn for speed)
- DC/OS Node
  - Docker CE w/ OverlayFS
  - curl, bash, ping, tar, xz, unzip, ipset
  - Disable firewalld
  - Create nogroup group
  - Disable IPv6
  - Enable IPv4 Forwarding (required by vagrant-hostmanager)
  - Cache docker images: nginx, zookeeper, registry
- Debug
  - jq
  - probe
  - net-tools
  - bind-utils
- Vagrant
  - Default Vagrant SSH key
  - Configure SSH daemon (disable DNS and API authn for speed)
  - Set box build time (`/etc/vagrant_box_build_time`)
- VirtualBox and VMware (Fusion and Workstation)
  - Guest Additions / VMware Tools Additions
  - Reset network interface config
  - Remove packages to reduce image size
- Zero out free space to improve image compression

## Build

The DC/OS Vagrant Box is normally built in CI, on demand, but can be built manually as well.

Note that because the build process uses internet repositories with unversioned requirements, it's not **exactly** reproducible. Each built box may be slightly different than the last, but installations using the same box should be exactly the same.


### Build Requirements

- [Packer](https://www.packer.io/) - tool for OS image building
- One of the following hypervisors:
    - [Oracle VirtualBox](https://www.virtualbox.org/) (>= 4.3)
    - [VMware Fusion](https://www.vmware.com/uk/products/fusion.html) (>=10)
    - [VMware Workstation Pro](https://www.vmware.com/uk/products/workstation-pro.html) (>=12)
- [Git](https://git-scm.com/) - for updating the Vagrant Box Catalog Metadata
- [Docker](https://www.docker.com/) - for running various other dependencies
- [OpenSSL](https://www.openssl.org/) - for generating box checksums

### Build Pipeline

1. Checkout - Clone or pull this repo
1. Clean - Delete any left over box files
1. Build - Use Packer to install the OS, runs all the build scripts, and export a compressed box file (~700MB)
1. Upload - Upload the new box to S3
1. Add - Add the new box version to the Vagrant Box Catalog Metadata (metadata.json)
1. Publish - Upload the updated Vagrant Box Catalog Metadata to S3

Note that because the build process uses internet repositories with unversioned requirements, it's not **exactly** reproducible. Each built box may be slightly different than the last, but installations using the same box should be exactly the same.

### Manual Build

Use the following commands to build a dcos-centos-virtualbox box:

```bash
cd <dcos-vagrant-box>
packer build -except=vmware-iso packer-template.json
```

## Test

New boxes can be tested with either the Vagrantfile in this repo or (preferably) with [miniDC/OS](https://minidcos.readthedocs.io/en/latest/).

### Test Requirements

- [Vagrant](https://www.vagrantup.com/) (>= 1.8.1)
- [VirtualBox](https://www.virtualbox.org/) (>= 4.3)
  - [VBGuest Plugin](https://github.com/dotless-de/vagrant-vbguest)

#### Install Vagrant VBGuest Plugin

The [VBGuest Plugin](https://github.com/dotless-de/vagrant-vbguest) manages automatically installing VirtualBox Guest Additions appropriate to your local Vagrant version on each new VirtualBox VM as it is created.

```bash
vagrant plugin install vagrant-vbguest
```

This allows the pre-built vagrant box image to work on multiple (and future) versions of VirtualBox.

### Test Local Box

To test a new local box (e.g. after `ci/build_release.sh`), add the box to vagrant and set the `DCOS_BOX_VERSION` environment variable:

```
cd <dcos-vagrant-box>
vagrant box add mesosphere/dcos-centos-virtualbox dcos-centos-virtualbox.box
export DCOS_BOX_VERSION=0
vagrant up
```

Or with [dcos-vagrant](https://github.com/mesosphere/dcos-vagrant):

```
cd <dcos-vagrant>
vagrant box add mesosphere/dcos-centos-virtualbox dcos-centos-virtualbox.box
export DCOS_BOX_VERSION=0
vagrant up [vms...]
```

To revert back to the remote Vagrant Box Catalog:

```
unset DCOS_BOX_VERSION
vagrant box remove mesosphere/dcos-centos-virtualbox --box-version=0
```

### Test Local Catalog

To test a local Vagrant Box Catalog (e.g. after `ci/update_catalog.sh`), set the `DCOS_BOX_URL` environment variable:

```
cd <dcos-vagrant-box>
export DCOS_BOX_URL=file://~/workspace/dcos-vagrant-box/metadata.json
vagrant up
```

Or with [dcos-vagrant](https://github.com/mesosphere/dcos-vagrant):

```
cd <dcos-vagrant>
export DCOS_BOX_URL=file://~/workspace/dcos-vagrant-box/metadata.json
vagrant up [vms...]
```

To revert back to the remote Vagrant Box Catalog:

```
unset DCOS_BOX_URL
echo -n "https://downloads.dcos.io/dcos-vagrant/metadata.json" > ~/.vagrant.d/boxes/mesosphere-VAGRANTSLASH-dcos-centos-virtualbox/metadata_url
```

# License

Copyright 2019 Mesosphere, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this repository except in compliance with the License.

The contents of this repository are solely licensed under the terms described in the [LICENSE file](./LICENSE) included in this repository.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
