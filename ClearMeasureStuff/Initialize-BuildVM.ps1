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

.PARAMETER Roles
Octopus Roles

.PARAMETER AgentPool
Pool for the agent, defaults to "AgentPool"

.PARAMETER InstanceName
SQL Instance name, defaults to sqlexpress2017

.PARAMETER Folder
Folder where to run this, defaults to c:\agent

.PARAMETER Environments
Octopus Environments

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
[Parameter(Mandatory)]
[string] $OctopusApiKey,
[Parameter(Mandatory)]
[string] $OctopusThumbprint,
[Parameter(Mandatory)]
[string[]] $Roles,
[Parameter(Mandatory)]
[string[]] $Environments,
[Parameter(Mandatory)]
[string] $PublicIp,
[string] $AgentPool = "AgentPool",
[string] $InstanceName = "sqlexpress2017",
[string] $Folder = "c:\agent",
[switch] $SkipVsts,
[switch] $SkipSql,
[switch] $SkipTentacle
)

mkdir $Folder -ErrorAction SilentlyContinue
Set-Location $Folder

$logFile = "$PWD\initialize-$(get-date -Format yyyyMMdd-hhmm).log"
$transcript = "$PWD\initialize-transcript-$(get-date -Format yyyyMMdd-hhmm).log"

Start-Transcript -Path $transcript
try {

    $userDomain = "$env:COMPUTERNAME\$AdminUserName"

    Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Starting init: SkipVsts: $SkipVsts SkipSql: $SkipSql SkipTentacle: $SkipTentacle"

    if ( !$SkipVsts )
    {
        & (Join-Path $PSScriptRoot "Add-VstsAgent.ps1") -LogFile $logFile -AccountUrl $AccountUrl -PAT $PAT -AdminUser $userDomain -AdminUserPwd $AdminUserPwd -AgentPool $AgentPool
    }

    if ( !$SkipSql )
    {
        & (Join-Path $PSScriptRoot "Install-SqlExpress.ps1") -LogFile $logFile -SaPwd $SaPwd -SvcPwd $SQLServicePwd -InstanceName $InstanceName -AdminUserDomain $userDomain
    }

    if ( !$SkipTentacle )
    {
        & (Join-Path $PSScriptRoot "Install-Tentacle.ps1") -LogFile $logFile -ApiKey $OctopusApiKey -Thumbprint $OctopusThumbprint -Roles $Roles -Environments $Environments -PublicIp $PublicIp
    }

}
finally {
    Stop-Transcript
}

