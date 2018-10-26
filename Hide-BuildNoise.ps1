function Hide-BuildNoise
{
[CmdletBinding()]
param(
[Parameter(ValueFromPipeline)]
[string] $line,
[switch] $Warning,
[switch] $PassThru
)

begin
{
    $start = Get-Date
    Write-Host "Started at $start"
}

process
{
    Set-StrictMode -Version Latest
    if ( $line )
    {
        if ( $line -clike '*: error *')
        {
            Write-Host "$line" -ForegroundColor Red
        }
        elseif ( $Warning -and $line -clike '*: warning *')
        {
            Write-Host "$line" -ForegroundColor Yellow
        }
        elseif ( $line -like "Done Building Project*")
        {
            Write-Host $line
        }
        elseif ( $line -match "\s+\d+ (Warning|Error)" )
        {
            Write-Host $line
        }
    }
    if ( $PassThru )
    {
        $line
    }
}

end
{
    $now = Get-Date
    Write-Host ("Ended at $now took {0:0.00} minutes" -f ($now - $start).TotalMinutes)
}

}

