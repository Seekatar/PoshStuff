<#
.SYNOPSIS
base64 conversion function

.DESCRIPTION
Convert to and from base64 like Linux base64 utility

.PARAMETER s
File name or string

.PARAMETER decode
Set to decode instead of encode

.PARAMETER Wrap
For encoding, line wrapping. Defaults to 76. 0 means no wrap

.PARAMETER Binary
Output will be a string by default. If you want the bytes, set this

.EXAMPLE
"TestApp.dll" | base64 -Wrap 120

Encode a file

.EXAMPLE
$temp = New-TemporaryFile
[System.IO.File]::WriteAllBytes( $temp, ($base64EncodingOfBinaryFile | base64 -d -binary))

Decode a binary file, note -binary

.EXAMPLE
"this is a test" | base64 | Set-Clipboard

Encode a string

.EXAMPLE
"dGhpcyBpcyBhIHRlc3Q=" | base64 -d

Decode a string
#>
function base64
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string] $s,
        [switch] $decode,
        [int] $Wrap = 76,
        [switch] $binary
    )

    process
    {
        Set-StrictMode -Version Latest
        $ErrorActionPreference = 'Stop'

        if ($s.Length -le 260 -and (Test-Path $s -PathType Leaf))
        {
            $str = Get-Content $s -AsByteStream
            $code = [System.Convert]::ToBase64String($str)
        }
        else
        {
            $code = [System.Convert]::ToBase64String([System.Text.Encoding]::utf8.GetBytes($s))
        }

        if ($decode)
        {
            if ($binary) {
                [System.Convert]::FromBase64String($s)
            } else {
                [System.Text.Encoding]::utf8.GetString( [System.Convert]::FromBase64String($s))
            }
        }
        else
        {
            if ($Wrap)
            {
                $temp = ""
                $len = $code.Length
                $start = 0
                while ($len -gt $Wrap)
                {
                    $temp += "$($code.Substring($start,$Wrap))`n"
                    $start += $Wrap
                    $len -= $Wrap
                }
                if ($len)
                {
                    $temp += $code.Substring($start)
                }
                $code = $temp
            }
            $code
        }
    }
}
