BeforeAll {
    . (Join-Path $PSScriptRoot base64.ps1)
}
# Pester 5 need to pass in TestCases object to pass share
$PSDefaultParameterValues = @{
    "It:TestCases" = @{
        encode = @"
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
EvBXVR8VP/RkEJSf6mlhQvjbQutuH1pfAAAA//8DAFBLAwQUAAAACAAne2ZSDSdJPJMBAACcAgAA
UQAAAHBhY2thZ2Uvc2VydmljZXMvbWV0YWRhdGEvY29yZS1wcm9wZXJ0aWVzLzJmMTgyNjE4MzQ1
OTQ5NTI4NDEwNDNlYmI0OGVhMmFjLnBzbWRjcGxSS4/TMBC+I/EfrJxbO2loWUqSFZsDByiqtBVw
de1pa9WxI89ks/33eK02VAj5Ys33mGf1+NpZ9gIBjXd1VvA8Y+CU18Yd62ygw/whe2zev6uUD7AN
vodABpBFlcO1VnV2IurXQvRDsNyHo9BKgIUOHKEoeCGyiUsQOvyvICET8xXNxBrHkY9l4i3yvBC/
N9+f1Qk6OTcOSToFV9WkwAQjj6W6iBx86CRhcuilOssjvDmtRAcktSQp3jqb91NrWeyWsUqrtQog
yYemlThIS5dK3AVvJA2ogukpjq/ZnQwya/ZBhgtT3pGMRbLR6CMQ6wAxJkcWK2KdUcEjhBejAJPv
vc/N2+g4RXMwEGtoW95+eea/ktnm6pWUd6wkvC6zibuMr8jzStxCCT/DZfRBY1OJ6ZsAK5E2cfPR
Sj9dmh/DVyD+NBir+U7iGfk2zm/Gfl6PZck/Rf+PxWIxY+1gaQhQOxgoSDtj22FvjfoGl50/g6vL
Yn8oH5YrqcvVByiXnyvxT7Z4YmkTf2+s+QMAAP//AwBQSwECFAAUAAAACAAne2ZSBzleyiUBAAAE
AgAACwAAAAAAAAAAAAAAAAAAAAAAX3JlbHMvLnJlbHNQSwECFAAUAAAACAAne2ZScJtTx6YBAAB9
AwAAHQAAAAAAAAAAAAAAAABOAQAAQ0NDLkNBUy5XaWRnZXRNZXNzYWdlcy5udXNwZWNQSwECFAAU
AAAACAAmo2ZSae1il5YUAAAANAAAJQAAAAAAAAAAAAAAAAAvAwAAbGliL25ldDUuMC9DQ0MuQ0FT
LldpZGdldE1lc3NhZ2VzLmRsbFBLAQIUABQAAAAIACd7ZlLefE281gAAANEBAAATAAAAAAAAAAAA
AAAAAAgYAABbQ29udGVudF9UeXBlc10ueG1sUEsBAhQAFAAAAAgAJ3tmUg0nSTyTAQAAnAIAAFEA
AAAAAAAAAAAAAAAADxkAAHBhY2thZ2Uvc2VydmljZXMvbWV0YWRhdGEvY29yZS1wcm9wZXJ0aWVz
LzJmMTgyNjE4MzQ1OTQ5NTI4NDEwNDNlYmI0OGVhMmFjLnBzbWRjcFBLBQYAAAAABQAFAJcBAAAR
GwAAAAA=
"@
}
}

Describe 'Test base64' {
    It 'EncodeString' {
        "https://landscape.canonical.com" | base64 | Should -Be "aHR0cHM6Ly9sYW5kc2NhcGUuY2Fub25pY2FsLmNvbQ=="
    }
    It 'DecodeString' {
        "aHR0cHM6Ly9sYW5kc2NhcGUuY2Fub25pY2FsLmNvbQ==" | base64 -d | Should -Be "https://landscape.canonical.com"
    }
    It 'EncodeFile' {
        (Join-Path $PSScriptRoot "./CCC.CAS.WidgetMessages.1.0.0.100.nupkg") | base64 | Should -Be $encode
    }
    It 'DecodeFile' {
        $temp = New-TemporaryFile
        [System.IO.File]::WriteAllBytes( $temp, ($encode | base64 -d -binary))

        fc.exe (Join-Path $PSScriptRoot "./CCC.CAS.WidgetMessages.1.0.0.100.nupkg") $temp /A | out-null
        Remove-Item $temp
        $LASTEXITCODE | Should -Be 0
    }
}

