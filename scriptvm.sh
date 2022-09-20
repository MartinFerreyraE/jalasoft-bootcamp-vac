#!/bin/sh

VBoxManage createvm --name VMDebian --ostype "Debian_64" --register --basefolder `pwd`
#Set memory and network
VBoxManage modifyvm VMDebian --ioapic on
VBoxManage modifyvm VMDebian --memory 1024 --vram 128
VBoxManage modifyvm VMDebian --nic1 nat
#Create Disk and connect Debian Iso
VBoxManage createhd --filename `pwd`/VMDebian/VMDebian_disk.vdi --size 80000 --format VDI
VBoxManage storagectl VMDebian --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach VMDebian --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  `pwd`/VMDebian/VMDebian_disk.vdi
VBoxManage storagectl VMDebian --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach VMDebian --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium `pwd`/debian.iso
VBoxManage modifyvm VMDebian --boot1 dvd --boot2 disk --boot3 none --boot4 none

#Enable RDP
VBoxManage modifyvm VMDebian --vrde on
VBoxManage modifyvm VMDebian --vrdemulticon on --vrdeport 10001

#Start the VM
VBoxHeadless --startvm VMDebian
