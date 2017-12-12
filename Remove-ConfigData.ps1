<#
.SYNOPSIS
Removes data in a JSON config file

.PARAMETER Path
Path to the config file

.PARAMETER Name
Name of the config data to remove

.OUTPUTS
$True if found and removed, $False if not found or file doesn't exist
#>
function Remove-ConfigData
{
[CmdletBinding()]
param(
[Parameter(Mandatory)]
[string] $Path,
[Parameter(Mandatory)]
[string] $Name
)
	Set-StrictMode -Version Latest

	$object = $null
	if ( Test-Path $Path )
	{
		$object = Get-Content $path -Raw | ConvertFrom-Json

        if ( Get-Member -InputObject $object -Name $Name )
        {
            $object.PSObject.Properties.Remove($Name)
        	Set-Content $path -Value (ConvertTo-Json $object)
            return $true
        }

	}

    $false
}