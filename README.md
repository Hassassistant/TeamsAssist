# TeamsAssist



# Introduction
We're working a lot at our home office these days. Several people already found inventive solutions to make working in the home office more comfortable. One of these ways is to automate activities in your home automatation system based on your status on Microsoft Teams.

Microsoft provides the status of your account that is used in Teams via the Graph API. To access the Graph API, your organization needs to grant consent for the organization so everybody can read their Teams status. Since my organization didn't want to grant consent, I needed to find a workaround, which I found in monitoring the Teams client logfile for certain changes.

This script makes use of two sensors that are created in Home Assistant up front:
* sensor.teams_status
* sensor.teams_activity

sensor.teams_status displays that availability status of your Teams client based on the icon overlay in the taskbar on Windows. sensor.teams_activity shows if you are in a call or not based on the App updates deamon, which is paused as soon as you join a call.

# Important
This solution is created to work with Home Assistant. It will work with any home automation platform that provides an API, but you probably need to change the PowerShell code.

# Requirements
* Create the three Teams sensors in the Home Assistant configuration.yaml file

```yaml
input_text:
  teams_status:
    name: Microsoft Teams status
    icon: mdi:microsoft-teams
  teams_activity:
    name: Microsoft Teams activity
    icon: mdi:phone-off

sensor:
  - platform: template
    sensors:
      teams_status: 
        friendly_name: "Microsoft Teams status"
        value_template: "{{states('input_text.teams_status')}}"
        icon_template: "{{state_attr('input_text.teams_status','icon')}}"
        unique_id: sensor.teams_status
      teams_activity:
        friendly_name: "Microsoft Teams activity"
        value_template: "{{states('input_text.teams_activity')}}"
        unique_id: sensor.teams_activity

```
* Generate a Long-lived access token ([see HA documentation](https://developers.home-assistant.io/docs/auth_api/#long-lived-access-token))
* Copy and temporarily save the token somewhere you can find it later
* Restart Home Assistant to have the new sensors added
* Download the files from this repository and save them to C:\Scripts
* Edit the Settings.ps1 file and:
  * Replace `<Insert token>` with the token you generated
  * Replace `<UserName>` with the username that is logged in to Teams and you want to monitor
  * Replace `<UserPass>` with the password of you windows login
  * Replace `<HA URL>` with the URL to your Home Assistant server
  * Adjust the language settings to your preferences
* Click and open the shortcut file called "Run".

After completing the steps below, start your Teams client and verify if the status and activity is updated as expected.

# BluePrint

[![Open your Home Assistant instance and show the blueprint import dialog with a specific blueprint pre-filled.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2FHassassistant%2FTeamsAssist%2Fblob%2Fmain%2FAutomation%2Fteams-light.yaml) 

Changes the color of a light based on your Teams status.


# Create Scheduled Task Without Microsoft Password.

If you want to use this script without requiring a Windows User Password, Edit the Create-Task.ps1 file with the below code.

```ps1
# Import the Settings.ps1 file
. "C:\Scripts\Settings.ps1"

# Run with Administrator privileges

# Get the current logged in user
$current_user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Define the action
$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-ExecutionPolicy Bypass -File `"C:\Scripts\Get-TeamsStatus.ps1`"" -WorkingDirectory "C:\Scripts"

# Define the trigger
$trigger = New-ScheduledTaskTrigger -AtStartup

# Define the settings
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd

# Create the task
Register-ScheduledTask -TaskName "Team Light 2" -Action $action -Trigger $trigger -Settings $settings -User $current_user

# Start the task
Start-ScheduledTask -TaskName "Team Light 2"


```
