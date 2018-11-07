##### snippet to load
ipmo C:\code\joat-powershell\joat-config\joat-config.psd1 -fo
ipmo vsteam -fo
ipmo C:\code\ClearMeasure\Internal-Playbook\scripts\Bootcamp\Bootcamp\Bootcamp.psm1 -fo -ArgumentList (Get-ConfigData Jw.BootcampPAT -Decrypt),jimwallace0953,CmBootCamp

ipmo C:\code\ClearMeasure\Internal-Playbook\scripts\Bootcamp\Bootcamp\Bootcamp.psm1 -ArgumentList (Get-ConfigData Cm.powershellpat -Decrypt),'clearmeasure','ClearMeasureBootcamp' -fo

##### snippet to setup the vsts agent, run in folder where installed it
$PAT = (Get-ConfigData -Name Jw.BootcampPAT -Decrypt)
$AccountUrl = "https://dev.azure.com/jimwallace0953/"
$AgentPool = "AgentPool"
$AdminUser = "bcadmin"
$AdminUserPwd = (Get-ConfigData -Name Jw.BootcampAdminPw -Decrypt)


.\config.cmd --unattended --url $AccountUrl --auth pat --token $PAT --pool $AgentPool --agent $env:COMPUTERNAME --windowsLogonAccount $AdminUser --windowsLogonPassword $AdminUserPwd --runAsService