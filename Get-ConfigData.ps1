<#
.SYNOPSIS
Get data from a JSON config file

.PARAMETER Path
Path to the config file

.PARAMETER Name
Name of the config data to get

.PARAMETER AsSecureString
Return the encrypted data as a SecureString

.PARAMETER DecryptString
Return encrypted data in clear text

.PARAMETER NoWarnIfNotFound
Don't kick out a Warning message if not found

.EXAMPLE
An example

.OUTPUTS
Object from config file, or $null
#>
function Get-ConfigData
{
[CmdletBinding()]
param(
[Parameter(Mandatory)]
[ValidateScript({Test-Path $_ -PathType Leaf})]
[string] $Path,
[Parameter(Mandatory)]
[string] $Name,
[switch] $AsSecureString,
[switch] $DecryptString,
[switch] $NoWarnIfNotFound
)
	Set-StrictMode -Version Latest

	$object = Get-Content $path -Raw | ConvertFrom-Json
	if ( Get-Member -InputObject $object -Name $Name)
	{
		$value = $object.$Name
		if ( $AsSecureString -or $DecryptString )
		{
			$secureString = $value | ConvertTo-SecureString
			if ( $DecryptString )
			{
				$value = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString))
			}
			else
			{
				$value = $secureString
			}
		}
		if ( $AsSecureString)
		{
			$value
		}
		else
		{
			ConvertFrom-Json $value
		}
	}
	elseif ( -not $NoWarnIfNotFound )
	{
		Write-Warning "Didn't find value named $name in $path"
	}
}