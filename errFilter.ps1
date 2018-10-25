function errFilter
{
[CmdletBinding()]
param(
[Parameter(ValueFromPipeline)]
[string] $line
)

process
{
    Set-StrictMode -Version Latest
    if ( $line -and $line -clike '* error *')
    {
        Write-Host $line -ForegroundColor Red
    }
    $line
}

}