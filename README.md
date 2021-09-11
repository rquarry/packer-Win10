# packer-Win10-VDI

## What is this?

- A set of configuration files used to build Windows 10 virtual machine images using [Packer](https://www.packer.io/) for VMware Workstation and Oracle VirtualBox.
- A [template pipeline](https://www.packer.io/guides/packer-on-cicd/pipelineing-builds) that uses the corresponding Windows 10 VM to build a VM for use with the U.S. Coast Guard CAC enabled infrastructure such as VDI and CG Portal.  

## Prerequisites

* [Packer](https://www.packer.io/downloads.html)
  * <https://www.packer.io/intro/getting-started/install.html>
* A Hypervisor
  * [VMware Workstation](https://www.vmware.com/products/workstation-pro.html)
  * [Oracle VM VirtualBox](https://www.virtualbox.org/)
* USCG VDI software [install archive (zip)](https://www.dcms.uscg.mil/Telework/FAQ/View/Article/2142333/how-do-i-set-up-vdi-software-on-my-personal-computer/)

## How to use

To create a Windows 10 VM image using VMware Workstation use the following commands:
```sh
cd c:\packer-Win10
packer build -only=vmware-iso win10.pkr.hcl
```

To create a Windows 10 VM image using Oracle VM VirtualBox use the following commands:
```sh
cd c:\packer-Win10
packer build -only=virtualbox-iso win10.pkr.hcl
```

*If you omit the keyword "-only=" images for both Workstation and Virtualbox will be created.*

By default the .iso of Windows 10 is pulled from the local HDD. This can be changed to a URL using the **"iso_url"** parameter in the **"variables"** section of the ```win10.pkr.hcl``` file.

```json
{
  "variables": {
      "iso_url": "http://cdn.digiboy.ir/?b=dlir-s3&f=SW_DVD5_WIN_ENT_LTSC_2019_64-bit_English_MLF_X21-96425.ISO"
}
```


## Configuring Input/User Locale & Timezone

To set the input/user locale and timezone according to your preferences edit the following file:

* ".\packer-Win2019\scripts\autounattend.xml"

```xml
<settings pass="specialize">
    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
        <InputLocale>fr-FR</InputLocale>
        <UserLocale>fr-FR</UserLocale>
    </component>
    <component xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
        <TimeZone>Romance Standard Time</TimeZone>
    </component>
</settings>
```
## Virtualbox Additions
The original author used ```virtualbox-guest-additions.ps1``` to download the latest version from the virtualbox website and install it on the VM. This repo has been changed to leverage Packer's automatic upload of the hosts version of this file, so no conflicts arise. The powershell script comments can be undone to revert back if needed.

## Default credentials

The default credentials for this VM image are:

|Username|Password|
|--------|--------|
|administrator|packer|
