#Requires -Version 3
<#
.SYNOPSIS
  Scriptlet to start a Windows Service. This should make updating/management of servers easier.
.DESCRIPTION
  This scriptlet is part of a series of scripts to assist on managing a CyberArk Env.
.PARAMETER ServiceName
    What is the service you want to stop?
    Examples:
        AppInfo
        ssh-agent
        Wcmsvc
.PARAMETER ServerName
    What is the server you are targeting?
.PARAMETER Timeout
    timeout in seconds.
    Default is 30.
.PARAMETER V
    Verbose. Will print out control messages during script execution.
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        1.0
  Author:         Luis Felipe Maeda
  Creation Date:  09-May-2022
  Purpose/Change: Initial script development
  
.EXAMPLE
  .\Start-Service.ps1 -ServiceName AppInfo -TargetMachine ExampleServer1 -V
#>


#--------[Params]---------------
Param(
  [parameter(Mandatory=$True)]  [String]  $ServiceName,
  [parameter(Mandatory=$False)] [switch]  $V,
  [parameter(Mandatory=$False)] [string]  $ServerName,
  [parameter(Mandatory=$False)] [int]     $Timeout
)

#--------[Script]---------------

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$scriptDir = Split-Path -LiteralPath $PSCommandPath
$startingLoc = Get-Location
Set-Location $scriptDir
$startingDir = [System.Environment]::CurrentDirectory
[System.Environment]::CurrentDirectory = $scriptDir

function Verbose {
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
 
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information'
    )
    if ($V){
      Write-Host "$($severity): $($Message)" -BackgroundColor Black -ForegroundColor Yellow
    }
}

try
{
    # $service_Obj = Get-WmiObject win32_Service -filter "name='$ServiceName'"
    <#
    Get-Service $ServiceName -ComputerName 'TheFelps' | Start-Service -PassThru
    Write-Output 0
    Write-Information 'This is some random info'
    #>
    
    # >>>>>> Insert script here.
    # 1. Validate if Service EXISTS
    # 2. try to start service
    # 3. dont respond till service status confirms status is really started. Default time out to 30 secs if none provided
    
    if(!$ServerName){
      $ServerName = $env:COMPUTERNAME
      Write-Host "No Server name was specified. Running on Local Machine."
    }
    if(!$Timeout){
      $TimeoutSecs = '00:00:'+30
      Write-Host "Timeout: "$TimeoutSecs
    } else {
      $TimeoutSecs = '00:00:'+$Timeout
      Write-Host "Timeout: "$TimeoutSecs
    }
    if ($V){
      Write-Host 'Verbose **************************' -BackgroundColor Black -ForegroundColor Yellow
      Write-Host "`t" -BackgroundColor Black -ForegroundColor Yellow
      Write-Host '**********************************' -BackgroundColor Black -ForegroundColor Yellow
    }

    if($service=Get-Service $ServiceName -ComputerName $ServerName){

      Verbose -Severity Information -Message "Service ($($ServiceName)) found"

      if($service.Status -eq 'Running'){
        Verbose -Severity Information -Message "Service is already running"
        Verbose -Severity Information -Message "Service Status: $($service.Status)"
        Exit 0
      } else {
        try {
          Verbose -Severity Information -Message "Attempting to start service $($ServiceName)"
          $service=Get-Service $ServiceName -ComputerName $ServerName | start-Service -PassThru
          $service.WaitForStatus('Running', $TimeoutSecs)
          
          if($service.Status -eq 'Running'){
            Verbose -Severity Information -Message "Service started!"
            Verbose -Severity Information -Message "Service Status: $($service.Status)"
            Write-Output 0 
          }
        }
        catch {
          Write-Host "Failed starting the service."
          Exit 1
        }
      }
    } else {
      Write-Error "no service $($ServiceName) found."
      exit $LASTEXITCODE
    }
}
finally
{
    Set-Location $startingLoc
    [System.Environment]::CurrentDirectory = $startingDir
    Write-Output "Done. Elapsed time: $($stopwatch.Elapsed)"
    Write-Output $LASTEXITCODE
}