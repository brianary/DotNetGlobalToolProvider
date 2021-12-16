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
	Write-Verbose "DotNetGlobalToolProvider: Listing installed packages like $Name"
	Write-Debug "Execute: dotnet tool list -g"
	$list = dotnet tool list -g
	Write-Debug ($list -join "`n")
	foreach($line in $list |where {$_ -match '^\S+\s+\d+(?:\.\d+)+\b'})
	{
		$package,$version,$commands = $line -split '\s\s+',3
		if($package -notlike $Name) {continue}
		@{
			FastPackageReference = @{Name = $package; Version = $version} |ConvertTo-Json -Compress
			Name = $package
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
	Write-Verbose "DotNetGlobalToolProvider: Searching for '$Name'"
	Write-Debug "Execute: dotnet tool search $Name"
	$find = dotnet tool search $Name
	Write-Debug ($find -join "`n")
	foreach($line in $find |where {$_ -match '^\S+\s+\d+(?:\.\d+)+\b'})
	{
		$package,$version,$authors,$downloads,$verified = $line -split '\s\s+',5
		$verified = $verified -eq 'x'
		@{
			FastPackageReference = @{Name = $package; Version = $version} |ConvertTo-Json -Compress
			Name = $package
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
