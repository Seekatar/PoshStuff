function Get-NugetSource
{
    Set-StrictMode -Version Latest
    $ErrorActionPreference = 'Stop'

    $sources = @()
    $inSource = $false
    $source = $null

    dotnet nuget list source | ForEach-Object {
        if ($_ -match "\s+\d+\.\s+([\w-\.]+) \[(.*)\]") {
            $inSource = $true
            $source = @{
                name = $Matches[1]
                enabled = $Matches[2] -eq 'Enabled'
                testedAndExists = $false
                path = ''
            }
        } elseif ($inSource) {
            $inSource = $false
            $source.path = $_.Trim()
            $sources += [PSCustomObject]$source
            $source = $null
        } else {
            $inSource = $false
        }
    }
    $sources
}