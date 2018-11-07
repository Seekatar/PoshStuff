# Get Users
$users = Invoke-BcAzureDevOpsMethod -PartialUrl "graph/users" -Verbose -NoProject -Vssps -Method GET
$users.value | ft

# Get Groups
$groups = Invoke-BcAzureDevOpsMethod -PartialUrl "graph/groups" -Verbose -NoProject -Vssps -Method GET
$group = $groups.value | ? displayname -eq 'Project Collection Build Service Accounts'
$groupsToCheck = $groups.value | ? displayname -in 'Project Collection Build Service Accounts','Project Collection Service Accounts'

# Get a group
# $group = Invoke-BcAzureDevOpsMethod -PartialUrl "graph/groups/$($group.descriptor)" -Verbose -NoProject -Vssps -Method GET

# get the memberships that *this* descriptor *is in*  NOT its own
$memberships = Invoke-BcAzureDevOpsMethod -PartialUrl "graph/memberships/$($group.descriptor)" -Verbose -NoProject -Vssps -Method GET
$memberships.value

# GET graph/memberships/{subjectDescriptor}/{containerDescriptor} will check it
# PUT /memberships/{subjectDescriptor}/{containerDescriptor} will add it

# add the service to Project Collection Build Service Accounts if not there
$serviceUsers = $users.value | ? displayname -like 'Project Collection Build Service*'
foreach ( $u in $serviceUsers )
{
    foreach ( $g in $groupsToCheck )
    {
        $membership = Invoke-BcAzureDevOpsMethod -PartialUrl "graph/memberships/$($u.descriptor)/$($g.descriptor)" -NoProject -Vssps -Method HEAD
        if ( $membership )
        {
            "Already in group $($g.displayname)"
        }
        else
        {
            "Not in group $($g.displayname)"
            $result = Invoke-BcAzureDevOpsMethod -PartialUrl "graph/memberships/$($u.descriptor)/$($g.descriptor)" -NoProject -Vssps -Method PUT
        }
    }
}

# make sure  Project Collection Administrators has Project Collection Build Service Accounts