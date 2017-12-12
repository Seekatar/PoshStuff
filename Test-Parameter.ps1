<#
.SYNOPSIS
Test a parameter that has a default since validation doesn't run in those cases

.Outputs
Will throw if fails
#>
function Test-Parameter
{
[CmdletBinding()]
param(
[Parameter(Mandatory)]
[string] $ParameterName,
$ParameterValue,
[switch] $NotNullOrEmpty
)
    Set-StrictMode -Version Latest

    if ( $NotNullOrEmpty -and -not [bool]$ParameterValue )
    {
        throw "'$ParameterName' must have a value"
    }
}