foreach( $i in (Get-ChildItem (Join-Path $PSScriptRoot "*.ps1") -File ))
{
    . $i
}

Export-ModuleMember -Function "*-*"
