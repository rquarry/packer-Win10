variable "vm_name" {
  type    = string
  default = "VDI_vm"
}

variable "winrm_password" {
  type    = string
  default = "packer"
}

variable "winrm_username" {
  type    = string
  default = "Administrator"
}

source "virtualbox-ovf" "step_2" {
  shutdown_command = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  source_path      = "output-test1/packer_Win10.ovf"
  vm_name          = "${var.vm_name}"
  guest_additions_mode = "disable"
  http_directory	= "/home/ryan/Downloads"
  communicator		= "winrm"
  winrm_insecure       = true
  winrm_password       = "${var.winrm_password}"
  winrm_timeout        = "4h"
  winrm_use_ssl        = true
  winrm_username       = "${var.winrm_username}"
  skip_export		= false
}

build {
  sources = ["source.virtualbox-ovf.step_2"]
  
  provisioner "powershell" {
    script          = "scripts/install_vdi_files.ps1"
  }
}


