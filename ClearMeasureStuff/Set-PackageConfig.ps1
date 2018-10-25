$fname = "E:\PinPoint\nerderydevelopment\dev\Main\Pinpoint.Enterprise.Notifications.Services\packages.config"
$xml = [xml](Get-Content $fname -raw)
$node = $xml.packages.package | Where-Object id -eq "Newtonsoft.Json"
$node.version = '6.0.8'
$xml.Save($fname)
Get-Content $fname