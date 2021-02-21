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

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Folder = $PWD

Logit "Add-VstsAgent started"
Logit -indent "AccountUrl = $AccountUrl"
Logit -indent "AdminUser = $AdminUser"
Logit -indent "AgentPool = $AgentPool"
Logit -indent "PAT $($PAT[0]+"*"*$PAT.Length)"
Logit -indent "AdminUserPwd $($AdminUserPwd[0]+"*"*$AdminUserPwd.Length)"
Logit -indent "Folder is $Folder"

$fname = (Get-Item (Join-Path $PSScriptRoot "vsts-agent*.zip")).FullName
Logit -indent "fname is $fname"

Expand-Archive -Path $fname -DestinationPath $Folder -Force
Logit -indent "$fname expanded into $Folder"

# ok to remove if not there
.\config.cmd remove --unattended --auth pat --token $PAT 2>&1 >> $LogFile

.\config.cmd --unattended --url $AccountUrl --auth pat --token $PAT --pool $AgentPool --agent $env:COMPUTERNAME --windowsLogonAccount $AdminUser --windowsLogonPassword $AdminUserPwd --runAsService 2>&1 >> $LogFile
Logit -indent "config.cmd exited and LASTEXITCODE is $LASTEXITCODE" -LastExit $LASTEXITCODE


