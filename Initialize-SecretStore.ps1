<#
.Synopsis
	Sets up storage for the API key.
#>

#Requires -Version 7
#Requires -Modules Microsoft.PowerShell.SecretManagement,Microsoft.PowerShell.SecretStore
[CmdletBinding()] Param(
[pscredential] $ApiKey = (Get-Credential ([io.path]::GetFileNameWithoutExtension((Resolve-Path $PSScriptRoot\*.psd1))) -Message 'Enter API key')
)
if(!(Get-SecretVault PowerShellGallery -ErrorAction SilentlyContinue))
{
	Register-SecretVault PowerShellGallery -ModuleName Microsoft.PowerShell.SecretStore
}
Set-Secret $ApiKey.UserName -SecureStringSecret $ApiKey.Password -Vault PowerShellGallery
