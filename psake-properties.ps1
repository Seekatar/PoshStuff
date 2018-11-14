<#
Order of processing
1. Parameters from commandline are set
2. Properties block is run
3. Properties from command line then set

Use -parameters to add new values to the script you want to use in the properties block
Use -properties to override a value in properties block or add new value

$params = @{
    a = 'a from -parameters'
    b = 'b from -parameters'
    c = 'c from -parameters'
}
$propertyOverrides = @{
    c = 'c from -properties'
    e = 'e from -properties'
    f = 'f from -properties'
    h = 'h from -properties'
}

Invoke-psake .\psake-properties.ps1 -parameters $params -properties $propertyOverrides -notr

Output:
a = a from -parameters
b = b from property block
c = c from -properties
d = d from property block
e = e from -properties
f =
g = c from property block
h = h from -properties

#>

<#
1. This happens first from -parameters

$a = 'a from -parameters'
$b = 'b from -parameters'
$c = 'c from -parameters'
#>

# 2. then this block runs
properties {
    $b = "b from property block"
    $c = "c from property block"
    $d = "d from property block"
    $e = "e from property block"
    $g = $c
    $h = $c
}
<#
3. Then this runs from -properties

if c exists then $c = 'c from -properties'
if e exists then $e = 'e from -properties'
if f exists then $f = 'f from -properties'
if h exists then $h = 'h from -properties'
#>

task default -depends TestProperties

task TestProperties {
  "a = $a"  # set 1
  "b = $b"  # set in 1,2
  "c = $c " # set in 1,2,3
  "d = $d"  # set in 2
  "e = $e"  # set in 2,3
  "f = $f " # skipped setting in 3
  "g = $g " # set in 2 from 1
  "h = $h " # set in 2,3 from 1

  Assert ($a -eq "a from -parameters") "ow a"
  Assert ($b -eq "b from property block") "ow b"
  Assert ($c -eq "c from -properties") "ow c"
  Assert ($d -eq "d from property block") "ow d"
  Assert ($e -eq "e from -properties") "ow e"
  Assert ($f -eq $null) "ow f"
  Assert ($g -eq "c from property block") "ow g"
  Assert ($h -eq "h from -properties") "ow h"
}