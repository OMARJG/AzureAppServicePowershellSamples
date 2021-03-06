﻿. .\Functions.ps1 # This script contains the GetResourceGroupForWebApp Function and code of this script is @ https://github.com/puneet-gupta/AzureAppServicePowershellSamples/blob/master/Functions.ps1

$webAppName = "powershelldemowebapp"
$subscriptionId = "31af7401-5a70-49be-80c7-7a6b85da7287"

Login-AzureRmAccount 
Select-AzureRmSubscription -SubscriptionId $subscriptionId
$rgName = GetResourceGroupForWebApp $webAppName 

$webApp = Get-AzureRmResource -ResourceGroupName $rgName `
-ResourceType Microsoft.Web/sites/config `
-ResourceName $webAppName/web `
-ApiVersion 2015-08-01

$vdirs = $webApp.Properties.VirtualApplications   

$newVdir = @{ 
PhysicalPath="site\wwwroot\newvirtualdir"; 
PreloadEnabled =$true ; 
VirtualDirectories=$null; 
VirtualPath="/newvirtualdir" 
}

$vdirs += $newVdir

$PropertiesObject = @{VirtualApplications = $vdirs; }

Set-AzureRmResource -PropertyObject $PropertiesObject `
-ResourceGroupName $rgName `
-ResourceType Microsoft.Web/sites/config `
-ResourceName $webAppName/web `
-ApiVersion 2015-08-01 -Force


