<#
.SYNOPSIS
run on the newly minted build box to setup the agent and install SQLExpress2017

.DESCRIPTION
To be called as part of the CustomScriptExtension of an Azure VM

.PARAMETER AccountUrl
URL to the account for the Agent

.PARAMETER PAT
PAT for the user  for the Agent

.PARAMETER SQLServicePwd
Password for the SQL Server Service

.PARAMETER SaPwd
Password for the sa SQL Server user

.PARAMETER AdminUser
User name to run the service as

.PARAMETER AdminUserPwd
Password for AdminUser

.PARAMETER AgentPool
Pool for the agent, defaults to "AgentPool"

.PARAMETER InstanceName
SQL Instance name, defaults to sqlexpress2017

.PARAMETER Folder
Folder where to run this, defaults to c:\agent

#>
param(
[Parameter(Mandatory)]
[string] $AccountUrl,
[Parameter(Mandatory)]
[string] $PAT,
[Parameter(Mandatory)]
[string] $SQLServicePwd,
[Parameter(Mandatory)]
[string] $SaPwd,
[Parameter(Mandatory)]
[string] $AdminUserName,
[Parameter(Mandatory)]
[string] $AdminUserPwd,
[string] $AgentPool = "AgentPool",
[string] $InstanceName = "sqlexpress2017",
[string] $Folder = "c:\agent"
)

$logFile = ".\initialize-$(get-date -Format yyyyMMdd-hhmm).log"

mkdir $Folder -ErrorAction SilentlyContinue
Set-Location $Folder

$userDomain = "$env:COMPUTERNAME\$AdminUserName"

& (Join-Path $PSScriptRoot "Add-VstsAgent.ps1") -LogFile $logFile -AccountUrl $AccountUrl -PAT $PAT -AdminUser $userDomain -AdminUserPwd $AdminUserPwd -AgentPool $AgentPool

& (Join-Path $PSScriptRoot "Install-SqlExpress.ps1") -LogFile $logFile -SaPwd $SaPwd -SvcPwd $SQLServicePwd -InstanceName $InstanceName -AdminUserDomain $userDomain
