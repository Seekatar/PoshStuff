<#
.SYNOPSIS
Send a message to slack
#>
function Send-SlackNotice
{
[CmdletBinding()]
param(
[Parameter(Mandatory)]
[string] $Text,
[string] $Emoji,
[Parameter(Mandatory)]
[string] $UserName,
[ValidateNotNullOrEmpty()]
[string] $IconEmoji = ":robot_face:",
[string] $OverrideChannel,
[string] $ThreadTimestamp,
[switch] $Pin,
[Parameter(Mandatory,ParameterSetName="Token")]
[string] $Token,
[Parameter(Mandatory,ParameterSetName="TokenFromConfig")]
[string] $ConfigPath,
[Parameter(Mandatory,ParameterSetName="TokenFromConfig")]
[string] $TokenName

)
    Set-StrictMode -Version Latest

    if ( -not $Token )
    {
        $Token = Get-ConfigData -Path $ConfigPath -Name $TokenName
    }
    sendSlackApi -Api "chat.postMessage" -Text $text -Emoji $Emoji -UserName $UserName -IconEmoji $IconEmoji `
                    -OverrideChannel $OverrideChannel -Timestamp $ThreadTimestamp -Pin:$Pin -ThreadName "thread_ts" `
                    -Token $Token

}
