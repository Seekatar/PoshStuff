function sendSlackApi
{
[CmdletBinding()]
param(
[Parameter(Mandatory)]
[string] $Api,
[Parameter(Mandatory)]
[string] $Text,
[string] $Emoji,
[Parameter(Mandatory)]
[string] $UserName,
[Parameter(Mandatory)]
[string] $IconEmoji,
[string] $OverrideChannel,
[string] $Timestamp,
[switch] $Pin,
[Parameter(Mandatory)]
[string] $Token,
[ValidateNotNullOrEmpty()]
[string] $ThreadName = "ts"
)

    Set-StrictMode -Version Latest
    $uri = "https://slack.com/api/$Api"

    if ( $Emoji )
    {
        $Text = "$Emoji $Text"
    }

    $payload = @{ text=$Text
                channel="team-q-lounge"
                icon_emoji=$IconEmoji
                token = $Token
                username = $UserName
                }

    if ($Timestamp )
    {
        $payload[$ThreadName] = $Timestamp
    }

    if ( $OverrideChannel )
    {
        $payload["channel"] = $OverrideChannel
    }

    try
    {
        Write-Verbose "Calling slack $Api"
        $response = Invoke-RestMethod -Uri $uri -Body $payload -Method Post -Verbose:$false
        Write-Verbose $response
        if ( $response.ok )
        {
            Add-Member -InputObject $response -Name "link" -Value "https://collabnet.slack.com/conversation/$($response.channel)/p$($response.ts -replace '\.','')" -MemberType NoteProperty
            $response
            if ( $Pin )
            {
                $null = Invoke-RestMethod -Uri "https://slack.com/api/pins.add" -Body @{ timestamp=$response.ts
                                                                                    channel=$response.channel
                                                                                    token = $Token
                                                                                } -Method Post -Verbose:$false
            }
        }
        else
        {
            Write-Warning "Got non 'ok' response from Slack $Api`n$response"
        }
    }
    catch
    {
        Write-Warning "Exception talking to slack $Api`n$_"
    }
}