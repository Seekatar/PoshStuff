<#
.SYNOPSIS
Set data in a JSON config file

.PARAMETER Path
Path to the config file

.PARAMETER Name
Name of the config data to get

.PARAMETER Value
Object to save in the config.  May be simple or an object to ConvertTo-Json

.PARAMETER AsSecureString
Return the encrypted data as a SecureString

.PARAMETER EncryptString
Encrypt the string when storing it.  Only the current use can decrypt it.

.EXAMPLE
An example
#>
function Set-ConfigData
{
[CmdletBinding()]
param(
[Parameter(Mandatory)]
[string] $Path,
[Parameter(Mandatory)]
[string] $Name,
[Parameter(Mandatory)]
[object] $Value,
[switch] $EncryptString
)
	Set-StrictMode -Version Latest

	$object = $null
	if ( Test-Path $Path )
	{
		$object = Get-Content $path -Raw | ConvertFrom-Json
	}
	if ( -not $object )
	{
		$object = [PSCustomObject]@{}
	}

	if ( $value -is 'SecureString' )
	{
		$value = ConvertFrom-SecureString $Value
	}
	elseif ( $EncryptString )
	{
		$value = ConvertTo-SecureString (ConvertTo-Json $Value) -asplaintext -force | ConvertFrom-SecureString
	}
	else
	{
		$value = (ConvertTo-Json $Value)
	}

	if ( -not (Get-Member -InputObject $object -Name $Name))
	{
		Add-Member -InputObject $object -Name $Name -Value $value -MemberType NoteProperty
	}
	else
	{
		$object.$name = $value.ToString()
	}
	Set-Content $path -Value (ConvertTo-Json $object)
}