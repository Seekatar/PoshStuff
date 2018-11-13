<#
.SYNOPSIS
Install and configure a tentacle

.PARAMETER LogFile
File for logging

.PARAMETER APIKey
The Octopus APIKey

.PARAMETER Thumbprint
The Octopus machine thumbprint

.PARAMETER TentacleVersion
Version of the tentacle to install, defaults to 3.23.2-x64

.PARAMETER OutpusUrl
Url of your octopus server

#>
param(
[Parameter(Mandatory)]
[string] $LogFile,
[Parameter(Mandatory)]
[string] $APIKey,
[Parameter(Mandatory)]
[string] $Thumbprint,
[Parameter(Mandatory)]
[string[]] $Roles,
[Parameter(Mandatory)]
[string[]] $Environments,
[string] $TentacleVersion = "3.23.2-x64",
[string] $OctopusUrl = "https://clearmeasure.octopus.com"
)

Set-StrictMode -Version Latest

Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Install-Tentacle started"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) OctopusUrl is $OctopusUrl"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) TentacleVersion is $TentacleVersion"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Role is $Roles"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Environment is $Environments"

$fname = "Octopus.Tentacle.$TentacleVersion.msi"
Invoke-WebRequest "https://download.octopusdeploy.com/octopus/$fname" -OutFile $fname
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Downloaded $fname"
msiexec.exe /i $fname /quiet | out-null
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Tentacle Installer exited with $LASTEXITCODE"

Push-Location "C:\Program Files\Octopus Deploy\Tentacle"
$ErrorActionPreference = "Stop"

try
{
    .\Tentacle.exe create-instance --instance "Tentacle" --config "C:\Octopus\Tentacle.config" --console  | Out-null
    Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) create instance exited with $LASTEXITCODE"

    .\Tentacle.exe new-certificate --instance "Tentacle" --if-blank --console | Out-null
    Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) new-certificate exited with $LASTEXITCODE"

    .\Tentacle.exe configure --instance "Tentacle" --reset-trust --console | Out-null
    .\Tentacle.exe configure --instance "Tentacle" --home "C:\Octopus" --app "C:\Octopus\Applications" --port "10933" --console | Out-null
    .\Tentacle.exe configure --instance "Tentacle" --trust $Thumbprint --console | Out-null
    Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) config commands exited with $LASTEXITCODE"

    netsh.exe advfirewall firewall add rule "name=Octopus Deploy Tentacle" dir=in action=allow protocol=TCP localport=10933 | Out-null
    Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) netsh exited with $LASTEXITCODE"

    .\Tentacle.exe register-with --instance "Tentacle" --server $OctopusUrl --apiKey=$ApiKey --role $Roles --environment $Environments --comms-style TentaclePassive --console -publichostname $publicIp -force | Out-null
    Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) register with exited with $LASTEXITCODE"

    .\Tentacle.exe service --instance "Tentacle" --install --start --console | Out-null
    Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) service exited with $LASTEXITCODE"

}
catch
{
    Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Exception installing Tentacle $($_.ToString())"
    throw $_
}
finally
{
    Pop-Location
}