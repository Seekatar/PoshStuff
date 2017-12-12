<#
.SYNOPSIS
Get the counts for git

.OUTPUTS
Object with AheadBy BehindBy Updates Changes Adds HasRemote
#>
function Get-GitCount
{
[CmdletBinding()]
param()

    Test-Git
    $output = @(git status --porcelain=2 --branch 2>$null)
    if ( -not $output )
    {
        return $null
    }
    $ret = @{AheadBy=0;BehindBy=0;Changes=0;Adds=0;Updates=0;HasRemote=@($output | Where-Object { $_.StartsWith("#")}).Count -gt 3}

    if ( $output.Length -gt 3 -and  $output[3].StartsWith("#"))
    {
        if ( $output[3] -match "\+(\d+) \-(\d+)" )  # can be both
        {
            Write-Verbose "Ahead $($matches[1]) Behind $($matches[2])"

            $ret["AheadBy"]=[Int32]::Parse($matches[1])
            $ret["BehindBy"]=[Int32]::Parse($matches[2])
        }
        else
        {
            throw "Didn't get correct format for branch line output from git status for $PWD`n$output"
        }
    }

    if ( $output.Length -gt 2 )
    {
        $adds = @($output | Where-Object { $_.StartsWith("?")}).Count
        $changes = @($output | Where-Object { (-not $_.StartsWith("#")) -and (-not $_.StartsWith("!")) }).Count
        $ret["Changes"]=$changes
        $ret["Updates"]=$changes-$adds
        $ret["Adds"]=$adds
        Write-Verbose "Changes $changes Adds $adds"
    }

    [PSCustomObject] $ret
}