
variable "vcenter_server" {
  type        = string
  description = "The vCenter server address"
}

variable "username" {
  type        = string
  description = "The vSphere username"
}

variable "password" {
  type        = string
  description = "The vSphere password"
}

variable "datacenter" {
  type        = string
  description = "The name of the datacenter"
}

variable "vm_name" {
  type        = string
  description = "The name of the cluster"
}

variable "network" {
  type        = string
  description = "The name of the network"
}

variable "datastore" {
  type        = string
  description = "The name of the datastore"
}

variable "folder" {
  type        = string
  description = "The name of the folder"
}

variable "cpus" {
  type        = number
  description = "The name of the folder"
}

variable "cpu_cores" {
  type        = number
  description = "The name of the folder"
}

variable "ssh_username" {
  type        = string
  description = "The SSH username"
}

variable "ssh_password" {
  type        = string
  description = "The SSH password"
  sensitive   = true
}

variable "iso_checksum" {
  type        = string
  description = "The path to the ISO file"
}

variable "iso_url" {
  type        = string
  description = "The path to the ISO file"
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_insecure_connection" {
  type        = bool
  description = "Do not validate vCenter Server TLS certificate."
}

// vSphere Settings


variable "vsphere_host" {
  type        = string
  description = "The name of the target ESXi host."
}


variable "vsphere_folder" {
  type        = string
  description = "The name of the target vSphere folder."
  default     = ""
}

// Virtual Machine Settings

variable "vm_guest_os_language" {
  type        = string
  description = "The guest operating system lanugage."
  default     = "en_US"
}

variable "vm_guest_os_keyboard" {
  type        = string
  description = "The guest operating system keyboard input."
  default     = "us"
}

variable "vm_guest_os_timezone" {
  type        = string
  description = "The guest operating system timezone."
  default     = "UTC"
}

variable "vm_guest_os_type" {
  type        = string
  description = "The guest operating system type, also know as guestid."
}

variable "vm_mem_size" {
  type        = number
  description = "The size for the virtual memory in MB."
}

variable "vm_disk_size" {
  type        = number
  description = "The size for the virtual disk in MB."
}

variable "vm_disk_controller_type" {
  type        = list(string)
  description = "The virtual disk controller types in sequence."
  default     = ["pvscsi"]
}

variable "vm_disk_thin_provisioned" {
  type        = bool
  description = "Thin provision the virtual disk."
  default     = true
}

variable "vm_network_card" {
  type        = string
  description = "The virtual network card type."
  default     = "vmxnet3"
}

variable "http_directory" {
  type        = string
  description = "Dir where ks file is located."
  default     = "http"
}

variable "common_remove_cdrom" {
  type        = bool
  description = "Remove the virtual CD-ROM(s)."
  default     = true
}

// Template and Content Library Settings

variable "common_template_conversion" {
  type        = bool
  description = "Convert the virtual machine to template. Must be 'false' for content library."
  default     = true
}

variable "common_content_library_name" {
  type        = string
  description = "The name of the target vSphere content library, if used."
  default     = null
}

variable "common_content_library_ovf" {
  type        = bool
  description = "Export to content library as an OVF template."
  default     = true
}

variable "common_content_library_destroy" {
  type        = bool
  description = "Delete the virtual machine after exporting to the content library."
  default     = true
}

variable "common_content_library_skip_export" {
  type        = bool
  description = "Skip exporting the virtual machine to the content library. Option allows for testing/debugging without saving the machine image."
  default     = false
}

// OVF Export Settings

variable "common_ovf_export_enabled" {
  type        = bool
  description = "Enable OVF artifact export."
  default     = false
}

variable "common_ovf_export_overwrite" {
  type        = bool
  description = "Overwrite existing OVF artifact."
  default     = true
}

variable "common_http_ip" {
  type        = string
  description = "Define an IP address on the host to use for the HTTP server."
  default     = null
}


variable "vm_boot_order" {
  type        = string
  description = "The boot order for virtual machines devices."
  default     = "disk,cdrom"
}

variable "communicator_timeout" {
  type        = string
  description = "The timeout for the communicator protocol."
}

variable "build_username" {
  type        = string
  description = "The username to login to the guest operating system."
  sensitive   = true
}

variable "build_password_encrypted" {
  type        = string
  description = "The SHA-512 encrypted password to login to the guest operating system."
  sensitive   = true
}
variable "root_password_encrypted" {
  type        = string
  description = "The SHA-512 encrypted root password to login to the guest operating system."
  sensitive   = true
}

variable "base_url" {
  type        = string
  description = "The URL for OS install."
}

variable "ssh_key" {
  type        = string
  description = "passphrase for disk encryption."
}

variable "epel_url" {
  type        = string
  description = "url for EPEL repo"
}

variable "appstream_url" {
  type        = string
  description = "url for appstream repo"
}

variable "rhsm_org" {
  type        = string
  description = "ORG ID for RHSM"
}

variable "rhsm_activation_key" {
  type        = string
  description = "Activation Key for RHSM"
}

variable "build_hostname" {
  type        = string
  description = "hostname of template"
}
