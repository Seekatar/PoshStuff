<#
.SYNOPSIS
    Update git if needed by doing add and commit if anything not committed.
#>
function Update-Git
{
[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory)]
[ValidateScript({Test-Path $_ -PathType Container})]
[string] $Folder,
[Parameter(Mandatory)]
[string] $Comment,
[switch] $Push,
[switch] $Pull,
[switch] $Force)

    Set-StrictMode -Version Latest


    if ( $Pull -and (Get-GitCount).BehindBy )
    {
        Invoke-Git pull | Select-Object -SkipLast 1
    }

    Push-Location $Folder
    if ( (Get-GitCount).Changes -and $PSCmdlet.ShouldProcess("$((Get-GitCount).Changes) items", "Update Git"))
    {
        if ( $Force -or $ConfirmPreference -ne "None" -or (Read-Host -Prompt "Do you want commit to Git with $((Get-GitCount).Changes) items (y/N)?") -like 'y*' )
        {
            Invoke-Git "add ." | Select-Object -SkipLast 1
            Invoke-Git "commit -m `"$Comment`"" | Select-Object -SkipLast 1
        }
    }
    if ( $Push -and (Get-GitCount).AheadBy -gt 0 -and $PSCmdlet.ShouldProcess("$((Get-GitCount).AheadBy) commits", "Push to Git"))
    {
        try
        {
            Invoke-Git push | Select-Object -SkipLast 1
        }
        catch
        {
            # git error even if ok?
            Write-Warning ">> Error from git push`n$_"
        }
    }
    Pop-Location

}