Set-Location "E:\PinPoint\nerderydevelopment\Dev\Main"

foreach ($fname in (Get-ChildItem -r packages.config))
{
    $xml = [xml](Get-Content $fname -raw)
    $node = $xml.packages.package | Where-Object id -eq "Newtonsoft.Json"
    if ( $node -and $node.version -notlike '9*')
    {
        $node.version = '9.0.1'
        $xml.Save($fname)
        "Set $fname"
    }
    else 
    {
        "Skipped $fname"
    }
}

foreach ($fname in (Get-ChildItem -r *.csproj))
{
    $xml = [xml](Get-Content $fname -raw)
    $node = $xml.Project.ItemGroup.Reference  | Where-Object Include -like "Newtonsoft.Json*"
    if ( $node )
    {
        $node.Include = "Newtonsoft.Json, Version=9.0.0.0, Culture=neutral, PublicKeyToken=30ad4fe6b2a6aeed, processorArchitecture=MSIL"
        $node.HintPath = "..\packages\Newtonsoft.Json.9.0.1\lib\net45\Newtonsoft.Json.dll"
        $xml.Save($fname)
        "Set $fname"
    }
    else 
    {
        "Skipped $fname"
    }
}
