<#
.SYNOPSIS
Test to see if can run git, and throws if can't
#>
function Test-Git
{
[CmdletBinding()]
param()
    Set-StrictMode -Version Latest

    if ( -not (Get-Command git -ErrorAction Ignore))
    {
        throw "Git not in path or not installed"
    }
}