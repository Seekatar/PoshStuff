Import-Module (Join-Path (Join-Path $PSScriptRoot ..) common.psm1) -Force

Describe "StringTests" {
    $path = [System.IO.Path]::GetTempFileName()
	It "SetsGetsString" {
        Set-ConfigData -Path $path -Name "String1" -Value "abc"
        (Get-ConfigData -Path $path -Name "String1") | Should be "abc"
	}
	It "SetsGetsEncryptedString" {
        Set-ConfigData -Path $path -Name "String2" -Value "abc" -EncryptString
        (Get-ConfigData -Path $path -Name "String2" -DecryptString) | Should be "abc"
	}
    It "RemovesString" {
        Remove-ConfigData -Path $path -Name "String2" | should be $true
        Remove-ConfigData -Path $path -Name "String2" | should be $false
        Get-ConfigData -Path $path -Name "String2" | should be $null
    }
    Remove-Item $path
}

Describe "ObjectTest" {
    $path = [System.IO.Path]::GetTempFileName()
    Write-Warning $path
    $o = @{ a = @{ b = "testing"} }

    It "SetGetsObject" {
        Set-ConfigData -Path $path -Name "String1" -Value $o
        $ret = (Get-ConfigData -Path $path -Name "String1")
        $ret.a.b | Should be "testing"
    }
    It "SetGetsEncryptedObject" {
        Set-ConfigData -Path $path -Name "String2" -Value $o -EncryptString
        $ret = (Get-ConfigData -Path $path -Name "String2" -DecryptString)
        $ret.a.b | Should be "testing"
    }

    Remove-Item $path
}

Describe "MoreComplexObjectTest" {
    $path = [System.IO.Path]::GetTempFileName()
    Write-Warning $path
    $o = @{ a = @{ user = "testing"
                   password = "pw"
                   clientId = 123
                   tenantId = 345
} }

    It "SetGetsObject" {
        Set-ConfigData -Path $path -Name "String1" -Value $o
        $ret = (Get-ConfigData -Path $path -Name "String1")
        $ret.a.user | Should be "testing"
        $ret.a.tenantId | Should be 345
    }
    It "SetGetsEncryptedObject" {
        Set-ConfigData -Path $path -Name "String2" -Value $o -EncryptString
        $ret = (Get-ConfigData -Path $path -Name "String2" -DecryptString)
        $ret.a.user | Should be "testing"
        $ret.a.tenantId | Should be 345
    }

    Remove-Item $path
}

Describe "SecureStringTest" {
    $path = [System.IO.Path]::GetTempFileName()
    Write-Warning $path
    $ss = ConvertTo-SecureString -String "monkey123" -AsPlainText -Force

    It "SetGetsEncryptedObject" {
        Set-ConfigData -Path $path -Name "SString" -Value $ss
        $ret = (Get-ConfigData -Path $path -Name "SString" -AsSecureString)
        $ret | Should beoftype 'SecureString'
    }

    It "SetGetsEncryptedObject" {
        Set-ConfigData -Path $path -Name "SString" -Value $ss
        $ret = (Get-ConfigData -Path $path -Name "SString" -AsSecureString -DecryptString)
        $ret | Should be 'monkey123'
    }
    Remove-Item $path
}
