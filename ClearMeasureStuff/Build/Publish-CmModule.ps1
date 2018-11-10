<#
.SYNOPSIS
Publish the module

.PARAMETER BaseFolder
Base folder to the module, will be above .\$ModuleName\$ModuleName.psd1

.PARAMETER ModuleName
Name of the module

.PARAMETER PAT
Personal Access Token for publishing

.PARAMETER BuildId
Build id for last level of version number in module
#>
[CmdletBinding()]
param(
[Parameter(Mandatory)]
[ValidateScript({Test-Path $_ -PathType Container})]
[string] $BaseFolder,
[Parameter(Mandatory)]
[string] $ModuleName,
[Parameter(Mandatory)]
[string] $PAT,
[Parameter(Mandatory)]
[int] $BuildId
)
Set-StrictMode -Version Latest

Set-Location $BaseFolder

$version = (Test-ModuleManifest -Path .\$ModuleName\$ModuleName.psd1).Version
Update-ModuleManifest -Path .\$ModuleName\$ModuleName.psd1 -ModuleVersion ("{0}.{1}.{2}.{3}" -f $version.Major, $version.Major, $version.Build, $BuildId)

Publish-Module -Name .\$ModuleName -Repository CmGallery -NugetApiKey $PAT