
variable "boot_wait" {
  type    = string
  default = "5s"
}

variable "disk_size" {
  type    = string
  default = "40960"
}

variable "iso_checksum" {
  type    = string
  default = "6911E839448FA999B07C321FC70E7408FE122214F5C4E80A9CCC64D22D0D85EA"
}

variable "iso_url" {
  type    = string
  default = "../../Downloads/Win10_21H1_English_x64.iso"
}

variable "memsize" {
  type    = string
  default = "4092"
}

variable "numvcpus" {
  type    = string
  default = "2"
}

variable "vm_name" {
  type    = string
  default = "Win10_Temp"
}

variable "winrm_password" {
  type    = string
  default = "packer"
}

variable "winrm_username" {
  type    = string
  default = "Administrator"
}

source "virtualbox-iso" "test1" {
  boot_wait            = "${var.boot_wait}"
  communicator         = "winrm"
  disk_size            = "${var.disk_size}"
  floppy_files         = ["scripts/bios/autounattend.xml"]
  gfx_controller       = "vboxsvga"
  gfx_vram_size        = "48"
  guest_os_type        = "Windows10_64"
  headless             = false
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  shutdown_command     = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout     = "30m"
  vboxmanage           = [["modifyvm", "{{ .Name }}", "--memory", "${var.memsize}"], ["modifyvm", "{{ .Name }}", "--cpus", "${var.numvcpus}"], ["modifyvm", "{{ .Name }}", "--vrde", "off"]]
  vm_name              = "${var.vm_name}"
  winrm_insecure       = true
  winrm_password       = "${var.winrm_password}"
  winrm_timeout        = "4h"
  winrm_use_ssl        = true
  winrm_username       = "${var.winrm_username}"
}

source "vmware-iso" "test2" {
  boot_wait        = "${var.boot_wait}"
  communicator     = "winrm"
  disk_size        = "${var.disk_size}"
  disk_type_id     = "0"
  floppy_files     = ["scripts/bios/autounattend.xml"]
  guest_os_type    = "windows9-64"
  headless         = false
  http_directory   = "http"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  shutdown_command = "shutdown /s /t 5 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_timeout = "30m"
  skip_compaction  = false
  vm_name          = "${var.vm_name}"
  vmx_data = {
    memsize             = "${var.memsize}"
    numvcpus            = "${var.numvcpus}"
    "scsi0.virtualDev"  = "lsisas1068"
    "virtualHW.version" = "14"
  }
  winrm_insecure = true
  winrm_password = "${var.winrm_password}"
  winrm_timeout  = "4h"
  winrm_use_ssl  = true
  winrm_username = "${var.winrm_username}"
}

build {
  sources = ["source.virtualbox-iso.test1", "source.vmware-iso.test2"]

  provisioner "powershell" {
    only         = ["vmware-iso.test2"]
    pause_before = "1m0s"
    scripts      = ["scripts/vmware-tools.ps1"]
  }

  provisioner "powershell" {
    only             = ["virtualbox-iso.test1"]
    pause_before     = "1m0s"
    scripts          = ["scripts/virtualbox-guest-additions.ps1"]
  }

  provisioner "powershell" {
    scripts = ["scripts/setup.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }
  
  provisioner "powershell" {
    scripts = [""scripts/win-update.ps1"]
  }
    
  provisioner "windows-restart" {
    restart_timeout = "30m"
  }
  
  provisioner "powershell" {
    scripts = [""scripts/win-update.ps1"]
  }
  
  

  provisioner "powershell" {
    pause_before = "1m0s"
    scripts      = ["scripts/cleanup.ps1"]
  }

}
