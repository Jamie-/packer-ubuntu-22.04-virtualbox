# Ubuntu 22.04 Jammy Packer Example

This example uses the Jammy cloud OVA image and the Virtualbox OVF builder to build a custom image.

This method is particularly neat as it does not require any automation of the installer due to making use of the Ubuntu cloud image and cloud-init for the initial setup.

## Building

Typically the following would suffice for a simple build with defaults
```bash
packer build ubuntu.pkr.hcl
```

However due to a bug (not sure whether to class it as an Ubuntu or a Packer bug) it's not possible to use the 22.04 cloud OVA directly with packer.
A pre-packer step is required to rename the IDE controller in the source OVA so that it's compatible with the Packer `virtualbox-ovf` builder.
For more info see this issue: https://github.com/hashicorp/packer-plugin-virtualbox/issues/108

The included build script works around all this for you.
```bash
./build.sh
```
