# Build vars

variable "vm_name" {
  type = string
  default = "packer-jammy"
}

variable "ssh_username" {
  type = string
  default = "user"
}

variable "ssh_password" {
  type = string
  default = "password"
  sensitive = true
}

variable "ova_source_path" {
  type = string
  default = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.ova"
}

# Checksum disabled while we are modifying the Jammy OVA
# variable "ova_source_checksum" {
#   type = string
#   default = "sha256:80decd92b39aad995bb1a7a01ae64680514f33d5ef4e117c5193f0eab376294c"
# }

variable "data_directory" {
  type = string
  default = "./vm_data"
}

# Virtual Machine vars

variable "headless" {
  type = bool
  default = true
}

variable "vm_cpu_cores" {
  type = number
  default = 2
}

variable "vm_mem_size" {
  type = number
  default = 2048
}

source "virtualbox-ovf" "jammy" {
  vm_name = var.vm_name
  source_path = var.ova_source_path
  # checksum = var.ova_source_checksum
  headless = var.headless
  cd_files = ["${var.data_directory}/*"]
  cd_label = "cidata"
  ssh_password = var.ssh_password
  ssh_username = var.ssh_username
  ssh_port = 22
  ssh_timeout = "30m"
  shutdown_command = "sudo -S -E shutdown -P now"
  shutdown_timeout = "5m"
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--cpus", var.vm_cpu_cores],
    ["modifyvm", "{{ .Name }}", "--memory", var.vm_mem_size],
  ]
}

build {
  sources = [
    "source.virtualbox-ovf.jammy"]
  provisioner "shell" {
    inline = ["echo 'Hello, world' > ~/hello.txt"]
  }
}
