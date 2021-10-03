<#
.Synopsis
	Publishes the module.

.Link
	https://github.com/brianary/scripts/blob/main/Get-CachedCredential.ps1

.Link
	Get-CachedCredential.ps1
#>

#Requires -Version 6
[CmdletBinding()] Param()
Push-Location $PSScriptRoot
$Name = [io.path]::GetFileNameWithoutExtension((Resolve-Path *.psd1))
$key = Get-CachedCredential.ps1 $Name -Message 'Enter API key'
Import-LocalizedData -BindingVariable Module -FileName "$Name.psd1"
$Destination = "$env:USERPROFILE\Documents\PowerShell\Modules\$Name\$($Module.ModuleVersion)"
if(Test-Path $Destination -Type Container) {Split-Path $Destination |Remove-Item -Recurse -Force}
New-Item $Destination -Type Directory
Copy-Item "$Name.ps?1" $Destination
Import-Module $Name
Publish-Module -Name $Name -NuGetApiKey ($key.GetNetworkCredential().Password)
Pop-Location
