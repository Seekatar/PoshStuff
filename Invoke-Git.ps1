<#
.SYNOPSIS
Invoke git, handling its quirky stderr that isn't error

.PARAMETER Command
The git command and its parameters to execute

.Outputs
Git messages, and lastly the exit code

.Example
Invoke-Git push

.Example
Invoke-Git "add ."
#>
function Invoke-Git
{
param(
[Parameter(Mandatory)]
[string] $Command )

    try {

        $exit = 0
        $path = [System.IO.Path]::GetTempFileName()

        Invoke-Expression "git $Command 2> $path"
        $exit = $LASTEXITCODE
        if ( $exit -gt 0 )
        {
            Write-Error "Git exit code $exit for '$command'`n$(Get-Content $path)"
        }
        else
        {
            Get-Content $path | Select-Object -First 1
        }
        $exit
    }
    catch
    {
        Write-Warning "Error trying to run git ${command}: $_`n$($_.ScriptStackTrace)"
    }
    finally
    {
        if ( Test-Path $path )
        {
            Remove-Item $path
        }
    }
}
