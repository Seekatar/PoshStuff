<#
.SYNOPSIS
Get a list of config data names from file

.PARAMETER Path
Path to the config file

.PARAMETER NameLike
Like string to filter results

.EXAMPLE
An example

.OUTPUTS
Name of members matching the NameLike
#>
function Find-ConfigData
{
[CmdletBinding()]
param(
[Parameter(Mandatory)]
[ValidateScript({Test-Path $_ -PathType Leaf})]
[string] $Path,
[string] $NameLike = '*'
)
    Set-StrictMode -Version Latest

    $object = Get-Content $path -Raw | ConvertFrom-Json
    Get-Member -InputObject $object -MemberType NoteProperty | Where-Object Name -like $NameLike | Select-Object -ExpandProperty Name
}