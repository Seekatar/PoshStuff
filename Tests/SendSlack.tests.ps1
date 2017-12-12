Import-Module (Join-Path $PSScriptRoot "..\common.psm1") -fo
$stamp = (Get-Date).ToString("HHmm")

Describe "SendSlackTest" {

    It "BeginEndThread" {
        $ret = Send-SlackNotice -Text "Starting Deploy $stamp" -OverrideChannel "team-q-test" -Icon Start
        $ret | should not BeNullOrEmpty
        foreach ( $i in 1..5 )
        {
            $retthd = Send-SlackNotice -Text "Reply $stamp $i" -OverrideChannel "team-q-test" -ThreadTimeStamp $ret.ts -Emoji ":white_check_mark:"
            $retthd | should not BeNullOrEmpty
        }

        $ret = Send-SlackNotice -Text "Success $stamp <$($ret.link)|testLink>" -Emoji ":bomb:" -OverrideChannel "team-q-test"
        $ret | should not BeNullOrEmpty
    }
}


Describe "UpdateSlackTest" {

    It "BeginEndThread" {
        $ret = Send-SlackNotice -Text "Starting Deploy $stamp" -OverrideChannel "team-q-test" -Emoji ":runner:" -Pin
        $ret | should not BeNullOrEmpty
        foreach ( $i in 1..5 )
        {
            $retthd = Update-SlackNotice -Text "Reply $stamp $i" -OverrideChannel $ret.channel -Timestamp $ret.ts -Emoji ":white_check_mark:" -ThreadTimeStamp $ret.ts
            $retthd | should not BeNullOrEmpty
            Start-Sleep -Milliseconds 2000
        }

        $ret = Update-SlackNotice -Text "Finished $stamp" -OverrideChannel $ret.channel -Timestamp $ret.ts -Emoji ":white_check_mark:"  -ThreadTimeStamp $ret.ts
        $ret | should not BeNullOrEmpty
        $ret = Send-SlackNotice -Text "Finished <$($ret.link)|testLink> $stamp" -OverrideChannel "team-q-test" -Emoji ":raised_hands:"
        $ret | should not BeNullOrEmpty
    }
}
# https://versionone.slack.com/conversation/G65N7UQTG/p1499365432034511