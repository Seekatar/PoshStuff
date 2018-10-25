$todo = Invoke-RestMethod -Uri 'https://jsonplaceholder.typicode.com/todos/1'
$todo 
$todo.GetType()
$todos = Invoke-RestMethod -Uri 'https://jsonplaceholder.typicode.com/todos'
$todos | Out-GridView
$todos.GetType()
$todos[0].GetType()

$postObj = @{ userId = 1
              title = "testing $(get-date)"
              completed = $false }

irm -ur 'https://jsonplaceholder.typicode.com/posts' -Method Post -Body (ConvertTo-Json $postObj) -ContentType "application/json"


$encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$env:patoken"))
$resp = Invoke-RestMethod -Uri 'https://clearmeasure.visualstudio.com/DefaultCollection/_apis/projects?api-version=1.0' -Headers @{Authorization = "Basic $encodedPat"}
$resp.value | Out-GridView


$repos = Invoke-RestMethod -Method Get -Uri "https://api.github.com/orgs/klwine/repos" -Headers @{Authorization="token $env:gitToken";Accept="application/json"} 
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
$repos | ft

$cred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("demouser+carecoordinator@pinpointmd.com:test123"))
irm -ur "https://demo2-ent-auth.pinpointmd.com/session/token?clientid=urn:pinpointmd.com" -h @{Authorization="Basic $cred";Accept="application/json"; Referer="https://demo2-ent-web.pinpointmd.com/Login"};

<# 
F12 Dev tools will generate PowerShell

Other useful options
-UseBasicParsing
-MaximumRedirection
#>