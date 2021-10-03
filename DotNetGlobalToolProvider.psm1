# see https://github.com/OneGet/oneget/blob/WIP/docs/writepowershellbasedprovider.md
function Get-PackageProviderName { return 'DotNetGlobalToolProvider' }
function Initialize-Provider { Get-Command dotnet -CommandType Application |Out-Null }
function Get-InstalledPackage
{
    [CmdletBinding()] Param(
        [string] $Name,
        [string] $RequiredVersion,
        [string] $MinimumVersion,
        [string] $MaximumVersion
    )
	Write-Verbose "DotNetGlobalToolProvider: Listing installed packages"
	foreach($line in dotnet tool list -g |select -Skip 2)
	{
		$package,$version,$commands = $line -split '\s\s+',3
		@{
			FastPackageReference = @{Name = $name; Version = $version} |ConvertTo-Json -Compress
			PackageName = $package
			Name = $name
			Version = $version
			VersionScheme = 'MultiPartNumeric'
			Summary = "Authors: $authors; Downloads: $downloads; Verified: $verified"
			Source = 'dotnet tool list'
		} |foreach {New-SoftwareIdentity @_} |Write-Output
	}
}
function Find-Package {
	[CmdletBinding()] Param(
		[string] $Name,
		[string] $RequiredVersion,
		[string] $MinimumVersion,
		[string] $MaximumVersion
	)
	Write-Verbose "DotNetGlobalToolProvider: Searching for '$name'"
	foreach($line in dotnet tool search $name |select -Skip 2)
	{
		$package,$version,$authors,$downloads,$verified = $line -split '\s\s+',5
		$verified = $verified -eq 'x'
		@{
			FastPackageReference = @{Name = $name; Version = $version} |ConvertTo-Json -Compress
			Name = $name
			Version = $version
			VersionScheme = 'MultiPartNumeric'
			Summary = "Authors: $authors; Downloads: $downloads; Verified: $verified"
			Source = 'dotnet tool search'
		} |foreach {New-SoftwareIdentity @_} |Write-Output
	}
}
function Install-Package
{
	[CmdletBinding()] Param(
		[Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string] $FastPackageReference
	)
	$package = $FastPackageReference |ConvertFrom-Json
	Write-Verbose "DotNetGlobalToolProvider: Installing $($package.Name) version $($package.Version)"
	dotnet tool install -g $package.Name --version $package.Version
}
function Uninstall-Package
{
	[CmdletBinding()] Param(
		[Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string] $FastPackageReference
	)
	$package = $FastPackageReference |ConvertFrom-Json
	Write-Verbose "DotNetGlobalToolProvider: Uninstalling $($package.Name) (version $($package.Version) is ignored)"
	dotnet tool uninstall -g $package.Name
}