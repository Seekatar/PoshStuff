<#
.SYNOPSIS
Test to see if AWS Tools are installed, and you have a 'default' credential

.EXAMPLE
Test-AwsCredential
#>
function Test-AwsCredential
{
    Set-StrictMode -Version Latest

    if ( -not (Get-Command Write-S3Object -ErrorAction Ignore))
    {
        throw "AWS PowerShell tools not installed.  See https://aws.amazon.com/powershell/"
    }

    if ( -not (Get-AWSCredentials default))
    {
        throw "You must set a default AWS Profile. Set-AWSCredentials -StoreAs default -AccessKey <correctKey> -SecretKey <secretkey>;Initialize-AWSDefaults -ProfileName default -Region us-east-1"
    }
}