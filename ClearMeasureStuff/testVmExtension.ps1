# run on the newly minted build box.
param(
[Parameter(Mandatory)]
[sting] $AccountUrl,
[Parameter(Mandatory)]
[string] $PAT,
[string] $Folder = "c:\agent"
)

mkdir $Folder -ErrorAction SilentlyContinue
Set-Location $Folder

Add-Content ".\run.log" -Value "$(Get-Date) AccountUrl = $AccountUrl"
Add-Content ".\run.log" -Value "$(Get-Date) PAT len = $($PAT.Length)"

$fname = (Get-Item vsts-agent*.zip).FullName
Add-Content ".\run.log" -Value "$(Get-Date) fname is $fname"

Expand-Archive -Path $fname -DestinationPath $Folder
Add-Content ".\run.log" -Value "$(Get-Date) $fname expanded into $Folder"

.\config.cmd --unattended --url $AccountUrl --auth pat --token $PAT --pool default --agent $env:COMPUTERNAME --runAsService
