# see https://docs.microsoft.com/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest
# and https://docs.microsoft.com/powershell/module/microsoft.powershell.core/new-modulemanifest
@{
RootModule = 'DotNetGlobalToolProvider.psm1'
ModuleVersion = '0.0.5'
CompatiblePSEditions = @('Core')
GUID = '9b4f5ca2-41f0-4186-becb-c4fc2c8474c3'
Author = 'Brian Lalonde'
#CompanyName = 'Unknown'
Copyright = '(c) Brian Lalonde. All rights reserved.'
Description = 'OneGet package provider for dotnet global tools.'
PowerShellVersion = '6.0'
FunctionsToExport = @()
CmdletsToExport = @()
VariablesToExport = @()
AliasesToExport = @()
PrivateData = @{
	PackageManagementProviders = 'DotNetGlobalToolProvider.psm1'
	PSData = @{
		Tags = @('PackageManagement','Provider','OneGet','DotNetTool')
		LicenseUri = 'https://github.com/brianary/DotNetGlobalToolProvider/blob/master/LICENSE'
		ProjectUri = 'https://github.com/brianary/DotNetGlobalToolProvider/'
		#IconUri = 'http://webcoder.info/images/CertAdmin.svg'
		# ReleaseNotes = ''
	}
}
}
