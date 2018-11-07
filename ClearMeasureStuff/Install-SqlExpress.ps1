<#
.SYNOPSIS
download and install SQLExpress2017 using current directory

.DESCRIPTION
Call by Initialize-BuildVM.ps1

.PARAMETER LogFile
File for logging

.PARAMETER SvcPwd
Password for the SQL Server Service

.PARAMETER SaPwd
Password for the sa SQL Server user

.PARAMETER InstanceName
SQL Instance name, defaults to sqlexpress2017
#>
param(
[Parameter(Mandatory)]
[string] $LogFile,
[Parameter(Mandatory)]
[string] $SvcPwd,
[Parameter(Mandatory)]
[string] $SaPwd,
[Parameter(Mandatory)]
[string] $InstanceName,
[Parameter(Mandatory)]
[string] $AdminUserDomain
)
$ErrorActionPreference = "Stop"

$SQLSVCACCOUNT = "NT Service\MSSQL`$$($InstanceName)"
if ($InstanceName -eq "MSSQLSERVER")
{
    $SQLSVCACCOUNT = "NT Service\MSSQLSERVER"
}

# get the downloader/installer, can't use it to install, just download
$downloader = "SQLServer2017-SSEI-Expr.exe"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Downloading $downloader"
Invoke-WebRequest -Uri "https://download.microsoft.com/download/5/E/9/5E9B18CC-8FD5-467E-B5BF-BADE39C51F73/$downloader" -OutFile "$PWD\$downloader"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Running $downloader"
& ".\$downloader" /Action=Download /MediaPath=$PWD\sql /MediaType=Core /Q /HP 2>&1 >> $LogFile | out-null
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) $downloader exited with $LASTEXITCODE"

# installer is compressed, need to extract the files to get setup.exe
$installer = Get-Item "$PWD\sql\*.exe"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Installer is $installer"
if ( !$installer )
{
    throw "Can't find installer in $PWD\sql"
}
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Running $installer"
& $installer /x:$PWD\sql\setup /q 2>&1 >> $LogFile | out-null
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) $installer exited with $LASTEXITCODE"

# finally, run setup!
$setup = Get-Item "$PWD\sql\setup\setup.exe"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Setup is $setup"
if ( !$setup )
{
    throw "Can't find setup in $PWD\sql\setup"
}
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) User\Domain is '$env:USERDOMAIN\$env:USERNAME'"
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) Running $setup for instance $InstanceName"

<#
This ends up failing since user it ends up being the following since running as NETWORK SERVICE
/SQLSYSADMINACCOUNTS="$env:USERDOMAIN\$env:USERNAME" `

WORKGROUP\BootcampBuild$
#>


& $setup /q /ACTION=Install /FEATURES=SQL /INSTANCENAME=$InstanceName /SQLSVCACCOUNT="$SQLSVCACCOUNT" `
            /SQLSVCPASSWORD=$SvcPwd /ADDCURRENTUSERASSQLADMIN `
            /SQLSYSADMINACCOUNTS=$AdminUserDomain `
            /AGTSVCACCOUNT="NT AUTHORITY\Network Service" /SQLSVCINSTANTFILEINIT="True" /IACCEPTSQLSERVERLICENSETERMS `
            /SECURITYMODE=SQL /SAPWD=$SaPwd  2>&1 >> $LogFile | out-null
Add-Content -Encoding Unicode $LogFile -Value "$(Get-Date) $setup exited with $LASTEXITCODE"

