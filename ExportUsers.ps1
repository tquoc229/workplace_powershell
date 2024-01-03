
# Export Azure AD users of Enterprise Application
# HOW TO USE
# Open PowerShell Console
# 1. Run command: Install-Module AzureAD
# 2. Add list of emails into file: emails_to_remove.csv. Each email per line.
# 3. Update $app_name by your Enterprise application name.
# 4. Update file path
# 5. Run command: .\ExportUsers.ps1
#

Connect-AzureAD  
# Get Enterprise applications name and update here:
$app_name = "Workplace from Facebook v2.0"
$file_path  = "C:\Users\admin\Downloads\azuread_workplace_powershell\exported_users.csv"
$app = Get-AzureADServicePrincipal -Filter "displayName eq '$app_name'"

Write-Host "-- app --";
Write-Host ($app | Format-Table | Out-String);

foreach($ap in $app){  
    Get-AzureADServiceAppRoleAssignment -ObjectId $ap.objectId -All $true | Select-Object  ObjectId, PrincipalDisplayName, PrincipalType, ResourceDisplayName | Export-Csv -Path $file_path -NoTypeInformation -Append  
}  

