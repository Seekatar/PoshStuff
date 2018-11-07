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
[string] $AgentPool = "AgentPool",
[string] $InstanceName = "sqlexpress2017",
[string] $Folder = "c:\agent"
)

$logFile = ".\initialize-$(get-date -Format yyyyMMdd-hhmm).log"

mkdir $Folder -ErrorAction SilentlyContinue
Set-Location $Folder

Add-Content -Encoding Unicode $logFile -Value "$(Get-Date) AccountUrl = $AccountUrl"
Add-Content -Encoding Unicode $logFile -Value "$(Get-Date) PAT len = $($PAT.Length)"

$fname = (Get-Item (Join-Path $PSScriptRoot "vsts-agent*.zip")).FullName
Add-Content -Encoding Unicode $logFile -Value "$(Get-Date) fname is $fname"

Expand-Archive -Path $fname -DestinationPath $Folder -Force
Add-Content -Encoding Unicode $logFile -Value "$(Get-Date) $fname expanded into $Folder"

.\config.cmd --unattended --url $AccountUrl --auth pat --token $PAT --pool $AgentPool --agent $env:COMPUTERNAME --runAsService 2>&1 >> $LogFile
Add-Content -Encoding Unicode $logFile -Value "$(Get-Date) config.cmd exited and LASTEXITCODE is $LASTEXITCODE"

& (Join-Path $PSScriptRoot "Install-SqlExpress.ps1") -LogFile $logFile -SaPwd $SaPwd -SvcPwd $SQLServicePwd -InstanceName $InstanceName
