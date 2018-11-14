<#
.SYNOPSIS
Install and configure a tentacle

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
[string] $APIKey,
[Parameter(Mandatory)]
[string] $Thumbprint,
[Parameter(Mandatory)]
[string[]] $Roles,
[Parameter(Mandatory)]
[string[]] $Environments,
[Parameter(Mandatory)]
[string] $PublicIp,
[string] $TentacleVersion = "3.23.2-x64",
[string] $OctopusUrl = "https://clearmeasure.octopus.com"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Logit "Install-Tentacle started"
Logit -indent "APIKey $($APIKey[0]+"*"*$APIKey.Length)"
Logit -indent "Thumbprint $($Thumbprint[0]+"*"*$Thumbprint.Length)"
Logit -indent "OctopusUrl is $OctopusUrl"
Logit -indent "TentacleVersion is $TentacleVersion"
Logit -indent "Role is $Roles"
Logit -indent "Environment is $Environments"
Logit -indent "Public IP is $publicIp"


$fname = "Octopus.Tentacle.$TentacleVersion.msi"
Invoke-WebRequest "https://download.octopusdeploy.com/octopus/$fname" -OutFile $fname
Logit -indent "Downloaded $fname"
msiexec.exe /i $fname /quiet | out-null
Logit -indent "Tentacle Installer exited with $LASTEXITCODE" -lastexit $LASTEXITCODE

Push-Location "C:\Program Files\Octopus Deploy\Tentacle"
$ErrorActionPreference = "Stop"

try
{
    .\Tentacle.exe create-instance --instance "Tentacle" --config "C:\Octopus\Tentacle.config" --console  | Out-null
    Logit -indent "create instance exited with $LASTEXITCODE" -lastexit $LASTEXITCODE

    .\Tentacle.exe new-certificate --instance "Tentacle" --if-blank --console | Out-null
    Logit -indent "new-certificate exited with $LASTEXITCODE" -lastexit $LASTEXITCODE

    .\Tentacle.exe configure --instance "Tentacle" --reset-trust --console | Out-null
    .\Tentacle.exe configure --instance "Tentacle" --home "C:\Octopus" --app "C:\Octopus\Applications" --port "10933" --console | Out-null
    .\Tentacle.exe configure --instance "Tentacle" --trust $Thumbprint --console | Out-null
    Logit -indent "config commands exited with $LASTEXITCODE" -lastexit $LASTEXITCODE

    netsh.exe advfirewall firewall add rule "name=Octopus Deploy Tentacle" dir=in action=allow protocol=TCP localport=10933 | Out-null
    Logit -indent "netsh exited with $LASTEXITCODE" -lastexit $LASTEXITCODE

    $cmd = ".\Tentacle.exe register-with --instance 'Tentacle' --server $OctopusUrl --apiKey=$ApiKey --role $($Roles -join ' --role ') --environment $($Environments -join ' --environment ') --comms-style TentaclePassive --console -publichostname $publicIp -force | Out-null"
    Invoke-Expression $cmd
    Logit -indent "register with exited with $LASTEXITCODE" -lastexit $LASTEXITCODE

    .\Tentacle.exe service --instance "Tentacle" --install --start --console | Out-null
    Logit -indent "service exited with $LASTEXITCODE" -lastexit $LASTEXITCODE

}
finally
{
    Pop-Location
}