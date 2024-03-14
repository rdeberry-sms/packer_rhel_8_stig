packer {
  required_plugins {
    vmware = {
      source  = "github.com/hashicorp/vsphere"
      version = "~> 1"
    }
  }
}

locals {
  build_by          = "Built by: HashiCorp Packer ${packer.version}"
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_description = "Built on: ${local.build_date}\n${local.build_by}"
  manifest_date     = formatdate("YYYY-MM-DD hh:mm:ss", timestamp())
  manifest_path     = "${path.cwd}/manifests/"
  manifest_output   = "${local.manifest_path}${local.manifest_date}.json"
  data_source_content = {
    "/inst.ks" = templatefile("${abspath(path.root)}/http/inst.ks.pkrtpl.hcl", {
      vm_guest_os_language     = var.vm_guest_os_language
      vm_guest_os_keyboard     = var.vm_guest_os_keyboard
      vm_guest_os_timezone     = var.vm_guest_os_timezone
      base_url                 = var.base_url
      root_password_encrypted  = var.root_password_encrypted
      build_username           = var.build_username
      build_password_encrypted = var.build_password_encrypted
      ssh_password             = var.ssh_password
      ssh_key                  = var.ssh_key
      epel_url                 = var.epel_url
      appstream_url            = var.appstream_url
      rhsm_activation_key                 = var.rhsm_activation_key
      rhsm_org                 = var.rhsm_org
      build_hostname           = var.build_hostname

    })
  }
  data_source_command = "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/inst.ks"
}


source "vsphere-iso" "rl8_iso" {
  boot_command = [
    "<up><tab>",
    "inst.text ${local.data_source_command}",
    "<enter><wait><enter>"
  ]
  guest_os_type       = var.vm_guest_os_type
  vcenter_server      = var.vcenter_server
  username            = var.username
  password            = var.password
  insecure_connection = var.vsphere_insecure_connection
  datacenter          = var.datacenter
  ssh_username        = var.ssh_username
  ssh_password        = var.ssh_password
  ssh_timeout         = var.communicator_timeout
  CPUs                = var.cpus
  cpu_cores           = var.cpu_cores
  RAM                 = var.vm_mem_size
  vm_name             = var.vm_name
  network_adapters {
    network      = var.network
    network_card = var.vm_network_card

  }
  http_content         = local.data_source_content
  iso_checksum         = var.iso_checksum
  iso_url              = var.iso_url
  datastore            = var.datastore
  folder               = var.folder
  convert_to_template  = var.common_template_conversion
  host                 = var.vsphere_host
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin_provisioned
  }
}


build {
  sources = ["vsphere-iso.rl8_iso"]
  provisioner "shell" {
    script          = "scripts/stig.sh"
    execute_command = "{{.Vars}} sudo bash '{{.Path}}'"
  }
}

