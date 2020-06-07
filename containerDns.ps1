$IsAdmin=[Security.Principal.WindowsIdentity]::GetCurrent()
    If ((New-Object Security.Principal.WindowsPrincipal $IsAdmin).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $FALSE)
    {
      "`nERROR: You are NOT a local administrator.  Run this script after logging on with a local administrator account." 
	 } else {
	 	
$containerName = $args[0]
$dnsName = $args[1]
if ($containerName -eq $null -OR $dnsName -eq $null) {
write-host "Please provide argument(s) 'containerName'/'dnsName'..."
} else {
$filePath = "C:\Windows\System32\drivers\etc\hosts"
#$filePath = "d:\test.txt"
$runningContainers = docker ps | awk '{print $NF}'
if ($runningContainers.length -gt 1) {

Foreach($container in $runningContainers) {

if ($containerName -eq $container){

write-host "$container running..."
$containerIPAddr = docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $containerName
write-host "$container ip address : $containerIPAddr"
$containerDnsName =$containerIPAddr + " " + $dnsName

If ((Get-Content $filePath | %{$_ -match $containerDnsName}) -contains $true) {
    write-host "Contains String"
}
else {
If ((Get-Content $filePath | %{$_ -match $dnsName}) -contains $true) {
	$linenumber= (Get-Content $filePath | select-string $dnsName).LineNumber
	$hostContent = {gc $filePath}.invoke()
	$hostContent.removeat($linenumber-1)
	Start-Sleep -s 2
	set-Content $filePath $hostContent
	Start-Sleep -s 2
}
	Add-Content -Path $filePath  -Value $containerDnsName
}

break
}
}
} else {
write-host "No containers are running. Please start containers..."
}
}
 }