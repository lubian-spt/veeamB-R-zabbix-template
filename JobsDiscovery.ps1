
#Get Veeam Jobs - In some cases, a warning appear telling that this cmdlet is not used anymore, the -warningaction removes that
$jobs = Get-VBRJob -WarningAction SilentlyContinue

#Creates the array object
$data = New-Object System.Collections.ArrayList

#Start a foreach to collect only the job name, and add to the array
foreach($j in $jobs){

$JobName = $j.Name

$data += @{"jobname"=$JobName}

}

#Convert the array to json
$data | ConvertTo-Json -Depth 10