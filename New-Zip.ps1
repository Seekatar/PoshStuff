<#
.SYNOPSIS
Create a new zip file

.DESCRIPTION
If a folder is passed in, the folder name is not used, but all files in the folder are used

.PARAMETER zipFile
The name of the zip file to create

.PARAMETER files
A number of files and folders to put in the zip

.EXAMPLE
An example
#>
function New-Zip
{
[CmdletBinding(SupportsShouldProcess)]
param(
[Parameter(Mandatory)]
[string] $zipFile,
[ValidateCount(1,99999)]
[string[]] $files )
    Set-StrictMode -Version Latest

    function addFolder
    {
    [CmdletBinding()]
    param( $archive, $zipFile, [string] $folder, [string] $basePath = "\" )

        Set-StrictMode -Version Latest

        foreach ( $f in Get-ChildItem $folder )
        {
            if ( Test-Path $f.FullName -PathType Container )
            {
                addFolder $archive $zipFile $f.FullName (Join-Path $basePath $f.Name)
            }
            else
            {
                $fname = (Join-Path $basePath $f.Name).Trim("\")
                Write-Verbose "Adding via $folder - $($f.FullName) as $fName to $zipFileName"
                $null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $f.FullName, $fname)
            }
        }

    }

    Add-Type -AssemblyName System.IO.Compression.FileSystem
    Add-Type -AssemblyName System.IO.Compression

    $zipFileName = [System.IO.Path]::GetTempFileName()
    Remove-Item $zipFileName -Force -WhatIf:$false

    $archive = [System.IO.Compression.ZipFile]::Open($zipFileName,[System.IO.Compression.ZipArchiveMode]::Create)
    if ( -not $archive)
    {
        return
    }

    foreach ( $file in $files )
    {
        $fileName = Split-Path $file -Leaf
        if ( $fileName.EndsWith( "*" ) )
        {
            addFolder $archive $zipFileName (Split-Path $file -parent)
        }
        elseif (Test-Path $file -PathType Container )
        {
            addFolder $archive $zipFileName $file
        }
        else
        {
            if ( Test-Path $file )
            {
                Write-Verbose "Adding $file -> $fileName to $zipFileName"
                $null = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file, $fileName )
            }
            else
            {
                throw "Can't find $file to add to $zipFileName"
            }
        }
    }
    $archive.Dispose()
    if ( $PSCmdlet.ShouldProcess($zipFile, "Copy $zipFileName"))
    {
        Copy-Item $zipFileName $zipFile
    }
    Remove-Item $zipFileName -Force -ErrorAction Ignore
}

