# Remove Azure AD users out of Enterprise Application
# HOW TO USE
# Open PowerShell Console
# 1. Run command: Install-Module AzureAD
# 2. Add list of emails into file: emails_to_remove.csv. Each email per line.
# 3. Update $app_name by your Enterprise application name.
# 4. Update file path
# 5. Run command: .\RemoveUserFromApp.ps1
#



Connect-AzureAD  
# Get Enterprise applications name and update here:
$app_name = "Workplace from Facebook v2.0"
$file_path  = "C:\Users\admin\Downloads\azuread_workplace_powershell\emails_to_remove.csv"
$app = Get-AzureADServicePrincipal -Filter "displayName eq '$app_name'"

Write-Host "--  app -- "
Write-Host ($app | Format-Table | Out-String)

foreach($line in Get-Content $file_path) {
    if($line -match $regex){
      $user = Get-AzureADUser -ObjectId "$line"
      #Get the ID of role assignment 
      $assignments = Get-AzureADServiceAppRoleAssignment -ObjectId $app.ObjectId | Where {$_.PrincipalDisplayName -eq $user.DisplayName}
      if($user -ne $null -and $assignments -ne $null) {
        Write-Host "--  User -- "
        Write-Host ($user | Format-Table | Out-String)

       
        Write-Host "--  assignments -- "
        Write-Host ($assignments | Format-Table | Out-String)
        Write-Host "--  Remove $line -- "
        Remove-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId  -AppRoleAssignmentId  $assignments.ObjectId
      }
    }
}
