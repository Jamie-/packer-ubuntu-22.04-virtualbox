#!/usr/bin/env bash

set -ex

if [ ! -f "./jammy-fixed.ova" ]; then
  echo "Downloading Jammy OVA..."
  wget -q "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
  # Workaround https://github.com/hashicorp/packer-plugin-virtualbox/issues/108
  echo "Renaming Jammy OVA IDE controller..."
  vboxmanage import --vsys 0 --vmname ubuntu-jammy "./jammy-server-cloudimg-amd64.ova"
  vboxmanage storagectl ubuntu-jammy --name IDE --rename "IDE Controller"
  vboxmanage export ubuntu-jammy -o "./jammy-fixed.ova"
  vboxmanage unregistervm ubuntu-jammy --delete
fi

packer build ubuntu.pkr.hcl
