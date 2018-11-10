<#
.SYNOPSIS
Register the Internal CM Gallery for publishing

.PARAMETER PAT
Personal Access Token for publishing

.PARAMETER PATUser
User for the PAT
#>
param(
[Parameter(Mandatory)]
[string] $PAT,
[Parameter(Mandatory)]
[string] $PATUser
)
Set-StrictMode -Version Latest

$securePassword =  ConvertTo-SecureString $PAT -asplaintext -force
$cred = New-Object System.Management.Automation.PSCredential ($PATUser, $securePassword)

$fullUrl = "https://clearmeasure.pkgs.visualstudio.com/_packaging/InternalPowerShellGallery/nuget/v2"

Register-PSRepository -Name CMGallery -SourceLocation $fullUrl -PublishLocation $fullUrl `
                      -InstallationPolicy Trusted -PackageManagementProvider NuGet -Verbose -Credential $cred