# DCOS Vagrant Box

This base OS image exists to speed up the process of installing DCOS on Vagrant managed VirtualBox VMs.

The DCOS Vagrant Box **does not include DCOS**, just it's dependencies.


## Contents

- CentOS 7+
- Docker
- Vagrant default SSH key
- VirtualBox Guest Additions
- Disabled firewalld
- Cached Docker images
  - nginx
  - jplock/zookeeper


## Build

The DCOS Vagrant Box is normally built in CI, on demand, but can be built manually as well.

Note that because the build process uses internet repositories with unversioned requirements, it's not **exactly** reproducible. Each built box may be slightly different than the last, but installations using the same box should be exactly the same.


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
packer build packer-template.json
```

To test a new local box, add the box to vagrant and set the `DCOS_BOX_VERSION` environment variable:

```
cd <dcos-vagrant-box>
vagrant box add mesosphere/dcos-centos-virtualbox build/dcos-centos-virtualbox.box
export DCOS_BOX_VERSION=0
vagrant up
```

The same method can be used to test a new local box with [dcos-vagrant](https://github.com/mesosphere/dcos-vagrant):

```
cd <dcos-vagrant>
vagrant box add mesosphere/dcos-centos-virtualbox build/dcos-centos-virtualbox.box
export DCOS_BOX_VERSION=0
vagrant up boot [vms...]
```


## License

Authors: Stathy Touloumis, Karl Isenberg

Copyright 2016 Mesosphere

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
