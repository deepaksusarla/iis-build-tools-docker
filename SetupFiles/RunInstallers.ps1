function runInstallers {
 Set-ExecutionPolicy Unrestricted
installChoco
installBuildTools
installMisc
}

function installChoco {
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Output "**************Installing Choco**************"
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
  Write-Output "**************Installation Done**************"
}

function installBuildTools {
Write-Output "**************Installing BuildTool**************"
 cinst -y visualstudio2017-workload-webbuildtools --params "--includeRecommended --includeOptional"
 Write-Output "**************Installation Done**************"
}

function installMisc {
 Write-Output "**************Installing GIT**************"
  choco install -y git.install
  Write-Output "**************Installing NODEJS**************"
  choco install -y nodejs
  Write-Output "**************Installing JRE8**************"
  choco install jdk8 -y
  Write-Output "**************Installation Done**************"
}

function setPath {
$env:PATH = $env:PATH + ';C:\Program Files (x86)\java\jdk1.8.0_251\bin';
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $env:PATH
$path = ($path.Split(';') | Where-Object { $_ -ne 'C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\MSBuild\Current\Bin' }) -join ';'
# Set it
[System.Environment]::SetEnvironmentVariable(
    'PATH',
    $path,
    'Machine'
)
$path = [System.Environment]::GetEnvironmentVariable(
    'PATH',
    'Machine'
)
}

runInstallers