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

.EXAMPLE
"C:\code\Service-Template\README.md" | base64 -Wrap 120 | Set-Clipboard

Encode a file

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
        [int] $Wrap = 76
    )

    process
    {
        Set-StrictMode -Version Latest

        if (Test-Path $s -PathType Leaf)
        {
            $s = Get-Content $s -Raw
        }
        if ($decode)
        {
            [System.Text.Encoding]::utf8.GetString( [System.Convert]::FromBase64String($s))
        }
        else
        {
            $code = [System.Convert]::ToBase64String([System.Text.Encoding]::utf8.GetBytes($s))
            if ($Wrap)
            {
                $len = $code.Length
                $start = 0
                while ($len -gt $Wrap)
                {
                    "$($code.Substring($start,$Wrap))"
                    $start += $Wrap
                    $len -= $Wrap
                }
                if ($len)
                {
                    $code.Substring($start)
                }
            }
            else
            {
                $code
            }
        }
    }
}