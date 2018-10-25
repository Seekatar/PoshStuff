[CmdletBinding(SupportsShouldProcess)]
param(
[switch] $Force
)
Set-StrictMode -Version Latest

$prevConfirm = $ConfirmPreference
if ( -not $Force )
{
    $ConfirmPreference = "Medium"
}

try
{

Write-Progress "Getting dirs"
$dirs = @(Get-ChildItem -r -Directory bin,obj)
$i = 0
if ( $PSCmdlet.ShouldProcess($PWD,"Wipe $($dirs.Count) child folders"))
{
    $ConfirmPreference = "High"
    foreach ( $dir in $dirs )
    {
        $pct = ([int](100*$i/$dirs.count))
        Write-Progress "Wiping $dir" -PercentComplete $pct -Status "$pct% complete"
        Remove-Item $dir -r -fo
        $i += 1
    }
}

}
finally
{
    $ConfirmPreference = $prevConfirm
}