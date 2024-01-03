# Add Azure AD users to Enterprise Application
# HOW TO USE
# Open PowerShell Console
# 1. Run command: Install-Module AzureAD
# 2. Add list of emails into file: emails_to_add.csv. Each email per line.
# 3. Update $app_name by your Enterprise application name.
# 4. Update file path
# 5. Run command: .\AddUsers.ps1
#



Connect-AzureAD  
# Get Enterprise applications name and update here:
$app_name = "Workplace from Facebook v2.0"
$file_path  = "C:\Users\admin\Downloads\azuread_workplace_powershell\emails_to_add.csv"
$app = Get-AzureADServicePrincipal -Filter "displayName eq '$app_name'"
$app_role_name = "User"
$appRole = $app.AppRoles | Where-Object { $_.DisplayName -eq $app_role_name }

Write-Host "--  app -- "
Write-Host ($app | Format-Table | Out-String)

foreach($line in Get-Content $file_path) {
    if($line -match $regex){
      $user = Get-AzureADUser -ObjectId "$line"
      if($user -ne $null) {
        Write-Host "--  User -- "
        Write-Host ($user | Format-Table | Out-String)
        New-AzureADUserAppRoleAssignment -ObjectId $user.ObjectId -PrincipalId $user.ObjectId -ResourceId $app.ObjectId -Id $appRole.Id
      }
    }
}
