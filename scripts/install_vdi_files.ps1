$vdi_zip = " http://$ENV:PACKER_HTTP_ADDR/VDI_Windows_64_Bit_Rem_Acc_Installation.zip"
$destination = "$ENV:TEMP\VDI_Windows_64_Bit_Rem_Acc_Installation.zip"
$vdi_file_folder = "$ENV:TEMP\VDI_Windows_64_Bit_Rem_Acc_Installation\"

echo "Downloading VDI files from host"

wget -Uri $vdi_zip -OutFile $destination

echo "Extracting archive"
Expand-Archive -Path $destination -DestinationPath $ENV:TEMP\

echo "Installing DOD Root certs"
msiexec.exe /i "$ENV:TEMP\3. InstallRoot_5.5x64.msi" /passive /norestart

Start-Sleep -Seconds 30

echo "installing ActiveClient"
start-process -Wait "$ENV:TEMP\ActivClient 7.2.1.exe"

Start-Sleep -Seconds 60

echo "installing ActiveClient registry fix"
reg.exe import "$ENV:TEMP\ActivClient VDI Fix.reg"

Start-Sleep -Seconds 60

echo "installing VMWare Horizon Client"
& "$ENV:TEMP\VMware-Horizon-Client-2012-8.1.0-17349995.exe" /silent /norestart

Start-Sleep -Seconds 120

copy-item "$ENV:TEMP\VDI-East.lnk" -Destination "$ENV:USERPROFILE\Desktop\"
copy-item "$ENV:TEMP\VDI-West.lnk" -Destination "$ENV:USERPROFILE\Desktop\"
copy-item "$ENV:TEMP\VDI-OSC.lnk" -Destination "$ENV:USERPROFILE\Desktop\"
