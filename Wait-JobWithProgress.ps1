<#
.SYNOPSIS
Generic function to wait on jobs showing progress, and wait time

.PARAMETER Jobs
One or more jobs to wait on

.PARAMETER ActivityName
Activity name for Write-Progres

.EXAMPLE
An example

#>
function Wait-JobWithProgress
{
[CmdletBinding()]
param(
[Parameter(Mandatory)]
[PSRemotingJob[]] $jobs,
[string] $ActivityName = "Waiting for jobs to complete"
)
Write-Progress -Activity $ActivityName -PercentComplete 0 

$total = $jobs.count
$start = Get-Date
while ( $jobs )
{
    $done = Wait-Job $jobs -Timeout 3 -Any
    if ( $done )
    {
        $jobs = @($jobs | Where-Object { $_ -notin $done })
        Write-Progress -Activity $ActivityName -PercentComplete (100*($total-($jobs.Count)) / $total) -CurrentOperation "$($total-($jobs.Count)) of $total complete"
    }

    Write-Progress -Activity $ActivityName -CurrentOperation "$($total-($jobs.Count)) of $total complete" -Status "Waiting on $($jobs.count) job$(if ($jobs.count -gt 1) { "s"}) for $([int]((Get-Date) - $start).TotalSeconds) seconds..."

}

Write-Progress -Activity $ActivityName -Completed

}