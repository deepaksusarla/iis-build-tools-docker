########################################################
#Check if running as administrator, if not then enables#
########################################################

If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))

{   
$arguments = "& '" + $myinvocation.mycommand.definition + "'"
Start-Process powershell -Verb runAs -ArgumentList $arguments
Break
}

#############################
#Make and download to folder#
#############################

New-Item -Path c:\VCRuntime -ItemType directory

Write "Download Microsoft Visual C++ 2005, 2008, 2010, 2012, 2013, 2015"
Write "Microsoft Visual C++ 2010 SP1 Redistributable Package (x86)" -Verbose
Invoke-WebRequest "http://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe" -OutFile "C:\VCRuntime\vcredist_x86_2010.exe"
Write "Microsoft Visual C++ 2010 SP1 Redistributable Package (x64)" -Verbose
Invoke-WebRequest "http://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe" -OutFile "C:\VCRuntime\vcredist_x64_2010.exe"
######################################
#Install the files from the directory#
######################################

$files = Get-ChildItem -Path "C:\VCRuntime\" -Filter *.exe

foreach($item in $files)
{
    Write-Output "Installing: $item"
     
    Start-Process -FilePath $item.FullName -ArgumentList "/install", "/passive", "/norestart", "'/log a.txt'" -PassThru | wait-process
    Write-Output "Installation of $item has been completed."
}

#Remove-Item -path "C:\VCRuntime" -recurse

Write-Output "All packages have been installed and cleanup performed."
