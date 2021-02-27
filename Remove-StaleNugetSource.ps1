<#
.SYNOPSIS
Remove or disable any unreachable nuget sources
#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
param(
    [switch] $Remove
)

$sources = @()
$ErrorActionPreference = 'Stop'
$inSource = $false
$source = $null

dotnet nuget list source | ForEach-Object {
    if ($_ -match "\s+\d+\.\s+([\w-\.]+) \[(.*)\]") {
        $inSource = $true
        $source = @{
            name = $Matches[1]
            enabled = $Matches[2] -eq 'Enabled'
            testedAndExists = $false
        }
    } elseif ($inSource) {
        $inSource = $false
        $source['path'] = $_.Trim()
        $sources += [PSCustomObject]$source
        $source = $null
    } else {
        $inSource = $false
    }
}

$sources | ForEach-Object {
    $removeIt = $false
    $source = $_
    if ($source.enabled -or $Remove) {
        if ($source.path -match '^[a-z]:') {
            $removeIt = !(Test-Path $source.path )
            $source.testedAndExists = !$removeIt
        } elseif ($source.path -like 'http*') {
            try {
                $null = Invoke-WebRequest $source.path
                $source.testedAndExists = $true
            } catch {
                $removeIt = $true
                Write-Verbose "Exception getting $($source.path)`n$_"
            }
        }
    }
    if ($removeIt) {
        Write-Verbose "Didn't find $($source.path)"
        if ($PSCmdlet.ShouldProcess($source.name,$Remove ? "Remove" : "Disable")) {
            if ($Remove) {
                dotnet nuget remove source $source.name
            } else {
                dotnet nuget disable source $source.name
            }
        }
    }
}

Write-Verbose ($sources | Format-Table -a | Out-String)
