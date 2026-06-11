$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$tomcatHome = Join-Path $root 'tools\tomcat\apache-tomcat-10.1.55'
$deployDir = Join-Path $tomcatHome 'webapps\ProjectIcchi'
$tomcatZip = Join-Path $root 'tools\apache-tomcat-10.1.55-windows-x64.zip'

if (-not (Test-Path $tomcatHome)) {
    $tomcatParent = Split-Path -Parent $tomcatHome
    if (-not (Test-Path $tomcatParent)) {
        New-Item -ItemType Directory -Path $tomcatParent | Out-Null
    }

    Invoke-WebRequest -Uri 'https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.55/bin/apache-tomcat-10.1.55-windows-x64.zip' -OutFile $tomcatZip
    Expand-Archive -Path $tomcatZip -DestinationPath (Join-Path $root 'tools\tomcat') -Force
}

$env:JAVA_HOME = 'C:\Program Files\OpenLogic\jdk-17.0.18.8-hotspot'
$env:CATALINA_HOME = $tomcatHome
$env:CATALINA_BASE = $tomcatHome
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"

if (Test-Path $deployDir) {
    Remove-Item $deployDir -Recurse -Force
}

New-Item -ItemType Directory -Path $deployDir | Out-Null
robocopy (Join-Path $root 'web') $deployDir /MIR /NFL /NDL /NJH /NJS /NP | Out-Null

& (Join-Path $tomcatHome 'bin\catalina.bat') run