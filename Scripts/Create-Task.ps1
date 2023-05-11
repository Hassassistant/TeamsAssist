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

# Create a SecureString for the password
$password = ConvertTo-SecureString $UserPass -AsPlainText -Force

# Create a PSCredential object
$credential = New-Object System.Management.Automation.PSCredential ($UserName, $password)

# Create the task
Register-ScheduledTask -TaskName "Team Light 2" -Action $action -Trigger $trigger -Settings $settings -User $credential.UserName -Password $credential.GetNetworkCredential().Password

# Start the task
Start-ScheduledTask -TaskName "Team Light 2"
