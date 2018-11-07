<#
.SYNOPSIS
Add the VSTS agent

.DESCRIPTION
To be called as part of the CustomScriptExtension of an Azure VM

.PARAMETER AccountUrl
URL to the account for the Agent

.PARAMETER PAT
PAT for the user  for the Agent

.PARAMETER AdminUser
User name to run the service as domain\user

.PARAMETER AdminUserPwd
Password for AdminUser

.PARAMETER AgentPool
Pool for the agent, defaults to "AgentPool"

#>
param(
[Parameter(Mandatory)]
[string] $LogFile,
[Parameter(Mandatory)]
[string] $AccountUrl,
[Parameter(Mandatory)]
[string] $PAT,
[Parameter(Mandatory)]
[string] $AdminUser,
[Parameter(Mandatory)]
[string] $AdminUserPwd,
[string] $AgentPool = "AgentPool"
)

Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) AccountUrl = $AccountUrl"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) PAT len = $($PAT.Length)"

$fname = (Get-Item (Join-Path $PSScriptRoot "vsts-agent*.zip")).FullName
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) fname is $fname"

Expand-Archive -Path $fname -DestinationPath $Folder -Force
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) $fname expanded into $Folder"

.\config.cmd --unattended --url $AccountUrl --auth pat --token $PAT --pool $AgentPool --agent $env:COMPUTERNAME --windowsLogonAccount $AdminUser --windowsLogonPassword $AdminUserPwd --runAsService 2>&1 >> $LogFile
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) config.cmd exited and LASTEXITCODE is $LASTEXITCODE"


