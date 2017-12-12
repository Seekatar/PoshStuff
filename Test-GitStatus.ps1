<#
.SYNOPSIS
Test the current folder and below for any uncommited or unpushed git changes

.OUTPUTS
Text of repo and if it has pending changes
#>
function Test-GitStatus
{
    Set-StrictMode -Version Latest

    function testGit( $parent )
    {
        $counts = Get-GitCount
        if ( $counts -and ( $counts.Changes -or $counts.Adds -or $counts.Updates ) )
        {
            "{0} has uncommited changes" -f $parent
        }
        elseif ( $counts -and $counts.AheadBy )
        {
            "{0} has unpushed changes" -f $parent
        }
    }

    if ( Test-Path ".\.git" )
    {
        testGit $PWD
    }
    else
    {
        $progress = "Checking folder"
        Write-Progress -Activity $progress -Status "Scanning folders under $PWD..."
        foreach ( $gitDir in (Get-ChildItem -Directory -Recurse ".git" ))
        {
            Write-Progress -Activity $progress -Status $gitDir
            $parent = Split-Path $gitDir -Parent
            Push-Location $parent
            try
            {
                testGit $parent
            }
            finally
            {
                Pop-Location
            }
        }
    }

}