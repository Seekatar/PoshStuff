Describe "Invoke-RestMethod Tests" {

It "Gets A Todo" {
    $todo = Invoke-RestMethod -Uri 'https://jsonplaceholder.typicode.com/todos/1'
    $todo | Should not be $null
    $todo | Should beOfType PsCustomObject
}

It "Gets Todos" {
    $todos = Invoke-RestMethod -Uri 'https://jsonplaceholder.typicode.com/todos'
    $todos.Count | Should BeGreaterThan 0
    $todos[0] | Should beOfType PsCustomObject
}

It "Posts" {
    $postObj = @{ userId = 1
                  title = "testing $(get-date)"
                  completed = $false }

    $result = irm -ur 'https://jsonplaceholder.typicode.com/posts' -Method Post -Body (ConvertTo-Json $postObj) -ContentType "application/json"
    $result.Id | Should be 101 
}

It "Gets VSTS Projects" {
    $encodedPat = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$env:patoken"))
    $resp = Invoke-RestMethod -Uri 'https://clearmeasure.visualstudio.com/DefaultCollection/_apis/projects?api-version=1.0' -Headers @{Authorization = "Basic $encodedPat"}
    $resp.value.Count | Should BeGreaterThan 0
}

It "Fails TLS" {
    if ( $PSVersionTable.PSVersion.Major -lt 6 )
    {
        { Invoke-RestMethod -Method Get -Uri "https://api.github.com/orgs/klwine/repos" -Headers @{Authorization="token $env:gitToken";Accept="application/json"} } | Should throw
    }
}

It "Succeeds TLS" {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    $repos = Invoke-RestMethod -Method Get -Uri "https://api.github.com/orgs/klwine/repos" -Headers @{Authorization="token $env:gitToken";Accept="application/json"} 
    $repos.Count | Should BeGreaterThan 0
}

It "Gets PinPoint Token" {
    $cred = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("demouser+carecoordinator@pinpointmd.com:test123"))
    $response = irm -ur "https://demo2-ent-auth.pinpointmd.com/session/token?clientid=urn:pinpointmd.com" -h @{Authorization="Basic $cred";Accept="application/json"; Referer="https://demo2-ent-web.pinpointmd.com/Login"};
    $response.Result | Should be "Valid"
}

<# 
F12 Dev tools will generate PowerShell

Other useful options
-UseBasicParsing
-MaximumRedirection
#>

}