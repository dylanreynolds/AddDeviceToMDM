
<#
.SYNOPSIS
  Used to join devices to Mobile Device Management
.DESCRIPTION
  This script will elevate your console, set the execution policy for the process,
  attempt to install the "Get-WindowsAutopilot" publish script and then run it with the GroupTag
  to join to Endpoint Management.
.OUTPUTS
  none
.NOTES
  Version:        1.0
  Author:         Dylan Reynolds
  Creation Date:  date 
  Purpose/Change: Initial script creation
.EXAMPLE
  Run the script with .\... and select either Y to continue or N to end.
#>

$Countdown = 5
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
  for ($PercentComplete = $Countdown; $PercentComplete -ge 0; $PercentComplete--) {
    Write-Progress -SecondsRemaining $PercentComplete -Activity "Requires admin elevation!" -Status "Please wait..."
    Start-Sleep -Seconds 1
  }
  Start-Process powershell.exe "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs 
  exit 
}
$executeScript = Read-Host "Do you want add this device to MDM - insert your Profile name here (Y/N)?" 
$executeScript = $executeScript.ToUpper()
$groupTag = "insert your profile"

if ($executeScript -eq "Y"){
    try{
        Write-Host "Starting script..." -ForegroundColor Yellow
        Start-Sleep -Seconds $Countdown
        Install-Script -name Get-WindowsAutopilotInfo -Force

        Write-Host "Running MDM Online with the $groupTag." -ForegroundColor Yellow
        Get-WindowsAutopilotInfo -Online -GroupTag $groupTag
    } catch{
       Write-Host "Failed to run script, see below error:" -ForegroundColor Yellow
       Write-Host $_
       Start-Sleep -Seconds $Countdown
    }
}







