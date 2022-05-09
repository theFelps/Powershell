#Requires -Version 3
<#
.SYNOPSIS
  Scriptlet to start a Windows Service
.DESCRIPTION
  This scriptlet is part of a series of scripts to assist on managing a CyberArk Env.
.PARAMETER ServiceName
    What is the service you want to stop?
    could be something like
        AppInfo
        ssh-agent
        Wcmsvc
.PARAMETER ServerName
    What is the server you are targeting?
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
  <Example goes here. Repeat this attribute for more than one example>
  .\Start-Service.ps1 -ServiceName AppInfo -TargetMachine ExampleServer1 -Verbose
#>


#--------[Params]---------------
Param(
  [parameter(Mandatory=$True)]
  [String]
  $ServiceName,
  [parameter(Mandatory=$False)]
  [bool]
  $VerboseMode,
  [parameter(Mandatory=$False)]
  [string]
  $ServerName
)

#if (-not($PSBoundParameters.ContainsKey("MyParam"))) {
#   Write-Output "Value from pipeline"
#}

#--------[Script]---------------


Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$scriptDir = Split-Path -LiteralPath $PSCommandPath
$startingLoc = Get-Location
Set-Location $scriptDir
$startingDir = [System.Environment]::CurrentDirectory
[System.Environment]::CurrentDirectory = $scriptDir

$ServerName = 'thefelps'

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
    Write-Host 'test'
}

try
{
    # $service_Obj = Get-WmiObject win32_Service -filter "name='$ServiceName'"

    <#

    Get-Service $ServiceName -ComputerName 'TheFelps' | Start-Service -PassThru

    Write-Output 0
    Write-Information 'This is some random info'
    
    #>

    
    # Get-Service $ServiceName -ComputerName 'TheFelps' | Stop-Service -PassThru


    # >>>>>> Insert script here.
    # 1. Validate if Service EXISTS
    if($service=Get-Service $ServiceName -ComputerName $ServerName){
        
        try {
            # Get-Service $ServiceName -ComputerName $ServerName | Start-Service -PassThru
            Get-Service $ServiceName | start-Service -PassThru
            $service.WaitForStatus($status, '00:00:30')
        }
        catch {
            
        }
    }
    # 2. try to start service
    # 3. dont respond till service status confirms status is really started. Default time out to 30 secs if none provided
}
finally
{
    Set-Location $startingLoc
    [System.Environment]::CurrentDirectory = $startingDir
    Write-Output "Done. Elapsed time: $($stopwatch.Elapsed)"
}