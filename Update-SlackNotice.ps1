<#
.SYNOPSIS
    Send a message to the a channel
#>
function Update-SlackNotice
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
[Parameter(Mandatory)]
[string] $Timestamp,
[Parameter(Mandatory)]
[string] $ThreadTimestamp,
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

    $ret = Send-SlackNotice -Text $Text -Emoji $Emoji -UserName $UserName -OverrideChannel $OverrideChannel `
                    -ThreadTimestamp $ThreadTimestamp -IconEmoji $IconEmoji `
                    -Token $Token

    if ( -not $ret )
    {
        return
    }

    sendSlackApi -Api "chat.update" -Text $text -Emoji $Emoji -UserName $UserName -IconEmoji $IconEmoji `
                    -OverrideChannel $OverrideChannel -Timestamp $Timestamp -Token $Token

}

