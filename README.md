Resize AzureRm Virtual Machine
==============================

            

There may be times when you have to scale your virtual machines up or down and changing the Virtual Machines size is straightforward, you can change the size of an Azure virtual machine by using either the Azure Management Portal
 or PowerShell commands. However, we often come across a strange yet descriptive error message. i.e. **” Storage account of type “Premium_LRS” is not support for VM size “Standard”.**


The above error occurs when you have selected Premium Storage (SSD) during provisioning and you try to change it to a plan that supports Standard Storage (HDD).


The Solution is very straight Forward, you need to change the OS disk first and then the VMSize.


So let's automate the entire process using PowerShell.


 



PowerShell
Edit|Remove
powershell
param(
[String]$VMname,
[String]$ResourceGroupName,
[String]$VmSize,
[String]$diskname,
[ValidateSet('StandardLRS','PremiumLRS')]
[String]$acctype
)
 
function Resize-vm($VMname,$ResourceGroupName,$VmSize,$diskname,$acctype)
{
#Stop the VM for which you need to change the size for.
Stop-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VMname
#Store the Disk in the Variable
$disk =  Get-AzureRmDisk -ResourceGroupName $ResourceGroupName -DiskName $diskname
#Change the Disk to Standard Storage
$disk.AccountType = $acctype
#Update the Azure Disk
Update-AzureRmDisk -ResourceGroupName $ResourceGroupName -DiskName $diskname -Disk $disk
#Now it's time to change the VM size.
$vm = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VMname
$vm.HardwareProfile.VmSize = $VmSize
Update-AzureRmVM -ResourceGroupName $ResourceGroupName -VM $vm
#Start your Azure VM
Start-AzureRmVM -ResourceGroupName $ResourceGroupName  -Name $VMname
}
Resize-vm -VMname '$VMname' -ResourceGroupName $ResourceGroupName -VmSize $VmSize -diskname $diskname -acctype $acctype

param( 
[String]$VMname, 
[String]$ResourceGroupName, 
[String]$VmSize, 
[String]$diskname, 
[ValidateSet('StandardLRS','PremiumLRS')] 
[String]$acctype 
) 
  
function Resize-vm($VMname,$ResourceGroupName,$VmSize,$diskname,$acctype) 
{ 
#Stop the VM for which you need to change the size for. 
Stop-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VMname 
#Store the Disk in the Variable 
$disk =  Get-AzureRmDisk -ResourceGroupName $ResourceGroupName -DiskName $diskname 
#Change the Disk to Standard Storage 
$disk.AccountType = $acctype 
#Update the Azure Disk 
Update-AzureRmDisk -ResourceGroupName $ResourceGroupName -DiskName $diskname -Disk $disk 
#Now it's time to change the VM size. 
$vm = Get-AzureRmVM -ResourceGroupName $ResourceGroupName -Name $VMname 
$vm.HardwareProfile.VmSize = $VmSize 
Update-AzureRmVM -ResourceGroupName $ResourceGroupName -VM $vm 
#Start your Azure VM 
Start-AzureRmVM -ResourceGroupName $ResourceGroupName  -Name $VMname 
} 
Resize-vm -VMname '$VMname' -ResourceGroupName $ResourceGroupName -VmSize $VmSize -diskname $diskname -acctype $acctype



Disclaimer

THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.


        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
