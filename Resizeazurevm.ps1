param(
[String]$VMname,
[String]$ResourceGroupName,
[String]$VmSize,
[String]$diskname,
[ValidateSet("StandardLRS","PremiumLRS")]
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
Resize-vm -VMname $VMname -ResourceGroupName $ResourceGroupName -VmSize $VmSize -diskname $diskname -acctype $acctype
