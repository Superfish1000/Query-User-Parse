$rawUserQuery=(query user)
$columnNames=("USERNAME", "SESSIONNAME", "ID", "STATE", "IDLE TIME", "LOGON TIME")
# The modifier below was introduced to correct the ID field since the ID number is anchored to the right side and expands to the left.  Thanks Microsoft.
# The maximum ID value is 65536, so the ID column override needs to be 5 digits long.
$columnStartModifier=(0, 0, -5, 0, 0, 0) # USERNAME, SESSIONNAME, ID, STATE, IDLE TIME, LOGON TIME
$columnStart=(
                (($rawUserQuery[0].IndexOf($columnNames[0])) + $columnStartModifier[0]),
                (($rawUserQuery[0].IndexOf($columnNames[1])) + $columnStartModifier[1]),
                (($rawUserQuery[0].IndexOf($columnNames[2])) + $columnStartModifier[2]),
                (($rawUserQuery[0].IndexOf($columnNames[3])) + $columnStartModifier[3]),
                (($rawUserQuery[0].IndexOf($columnNames[4])) + $columnStartModifier[4]),
                (($rawUserQuery[0].IndexOf($columnNames[5])) + $columnStartModifier[5])
)

$users=@()

for ( $i=1 ; $i -lt $rawUserQuery.length ; $i++)
{
    #Username
    $usernameLength=$columnStart[1]-1
    $usernameString=$rawUserQuery[$i].Substring($columnStart[0], $usernameLength).trim()

    #Session Name
    $sessionNameLength=$columnStart[2]-$columnStart[1]-1
    $sessionNameString=$rawUserQuery[$i].Substring($columnStart[1], $sessionNameLength).trim()

    #Session ID
    $sessionIdLength=$columnStart[3]-$columnStart[2]-1
    $sessionIdString=$rawUserQuery[$i].Substring($columnStart[2], $sessionIdLength).trim()

    #Session State
    $sessionStateLength=$columnStart[4]-$columnStart[3]-1
    $sessionStateString=$rawUserQuery[$i].Substring($columnStart[3], $sessionStateLength).trim()

    #Session Idle Time
    $sessionIdleTimeLength=$columnStart[5]-$columnStart[4]-1
    $sessionIdleTimeString=$rawUserQuery[$i].Substring($columnStart[4], $sessionIdleTimeLength).trim()

    #Session Logon Time
    $sessionLogonTimeLength=$rawUserQuery[$i].Length-$columnStart[5]
    $sessionLogonTimeString=$rawUserQuery[$i].Substring($columnStart[5], $sessionLogonTimeLength).trim()

    $users+=[PSCustomObject]@{username=$usernameString;sessionName=$sessionNameString;id=$sessionIdString;state=$sessionStateString;idleTime=$sessionIdleTimeString;logonTime=$sessionLogonTimeString}
}
$users
