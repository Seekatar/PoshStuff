# run on the newly minted build box to setup the agent and install SQLExpress2017
param(
[Parameter(Mandatory)]
[string] $AccountUrl,
[Parameter(Mandatory)]
[string] $PAT,
[Parameter(Mandatory)]
[string] $SQLServicePwd,
[Parameter(Mandatory)]
[string] $SaPwd,
[string] $InstanceName = "sqlexpress2017",
[string] $Folder = "c:\agent"
)

$logFile = ".\initialize-$(get-date -Format yyyyMMdd-hhmm)"

mkdir $Folder -ErrorAction SilentlyContinue
Set-Location $Folder

Add-Content $logFile -Value "$(Get-Date) AccountUrl = $AccountUrl"
Add-Content $logFile -Value "$(Get-Date) PAT len = $($PAT.Length)"

$fname = (Get-Item (Join-Path $PSScriptRoot "vsts-agent*.zip")).FullName
Add-Content $logFile -Value "$(Get-Date) fname is $fname"

Expand-Archive -Path $fname -DestinationPath $Folder -Force
Add-Content $logFile -Value "$(Get-Date) $fname expanded into $Folder"

.\config.cmd --unattended --url $AccountUrl --auth pat --token $PAT --pool default --agent $env:COMPUTERNAME --runAsService 2>&1 >> $LogFile
Add-Content $logFile -Value "$(Get-Date) Ran config.cmd"

.\Install-SqlExpress -LogFile $logFile -SaPwd $SaPwd -SvcPwd $SQLServicePwd -InstanceName $InstanceName
