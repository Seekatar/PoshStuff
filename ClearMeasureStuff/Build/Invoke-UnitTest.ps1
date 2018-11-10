
<#
.SYNOPSIS
Run the pester tests in a build

.PARAMETER TestFolder
Folder where the Pester tests live, will execute all with the tags specified

.PARAMETER ModuleName
Name of the PS Module.  Will import ..\$ModuleName\$ModuleName.psd1

.PARAMETER Tags
Test tags, defaults to PSSA, UnitTest (PS Script Analyzer)

.EXAMPLE
.\Invoke-Tests.ps1 -TestFolder $env:Build_SourcesDirectory\Tests -ModulePath $env:ModulePath

Called from AzureDevOps Build pipeline, ModulePath can be .\MyModule\MyModule.psd1, etc.
#>
param(
[Parameter(Mandatory)]
[ValidateScript({Test-Path $_ -PathType Container})]
[string] $TestFolder,
[Parameter(Mandatory)]
[string] $ModulePath,
[string[]] $Tags = @("PSSA","UnitTest")
)

if ( $PSVersionTable.PSVersion -lt "5.1")
{
    $PSVersionTable
    throw "Must have PS 5.1 or higher to use Module cmdlets with Credentials"
}

Import-Module $ModulePath

Set-Location $TestFolder

Install-PackageProvider -Name Nuget -Scope CurrentUser -Force -Confirm:$false | out-null
if ( -not (Get-Module -Name Pester ) )
{
    Install-Module -Name Pester -Scope CurrentUser -Force -Confirm:$false -SkipPublisherCheck
}
if ( -not (Get-Module -Name PSScriptAnalyzer ) )
{
    Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force -Confirm:$false -SkipPublisherCheck
}

Import-Module Pester
Import-Module PSScriptAnalyzer

$result = Invoke-Pester -OutputFile 'TEST-PesterResults.xml' -OutputFormat 'NUnitXml' -Tags $tags -PassThru
if ( $result.FailedCount )
{
    throw "Pester tests failed.  Count is $($result.FailedCount)"
}

