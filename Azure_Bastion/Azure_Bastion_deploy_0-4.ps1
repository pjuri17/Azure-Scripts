#Variables
$ResourceGroupABH = Read-Host -Prompt "Ente1r name of Resource Group where Azure Bastion Host will be created"
$Region = (Get-AzResourceGroup -Name $ResourceGroupABH).Location
# $ABHName = Read-Host -Prompt "Enter name of Azure Bastion Host"

 
#Code

$Vnets = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupABH
Write-Host "Please select Virtual Network where you want that Azure Bastion is deployed" -ForegroundColor Yellow
if ($Vnets.count -gt 0){
    Write-Host "Please select a Virtual Network" -ForegroundColor Yellow
    for($i = 0; $i -lt $Vnets.count; $i++){
        Write-Host "$($i): $($Vnets[$i].Name)"
    }
    $selection = Read-Host -Prompt "Enter the number of the Virtual Network"
    $ABHVnet = $VNets[$selection]
}
# New-AzResourceGroup -Name $ResourceGroupABH -Location $Region
$ABHName = "Bastion_" + $ABHVnet.Name
$ABHIPName = $ABHName + “-PIP”
$publicip = New-AzPublicIpAddress -ResourceGroupName $ResourceGroupABH -name $ABHIPName -location $Region -AllocationMethod Static -Sku Standard -Tier Regional
New-AzBastion -ResourceGroupName $ResourceGroupABH -Name $ABHName -PublicIpAddress $publicip -VirtualNetwork $ABHVnet
Get-AzBastion -ResourceGroupName $ResourceGroupABH -Name $ABHName | Format-Table Name, ResourceGroupName