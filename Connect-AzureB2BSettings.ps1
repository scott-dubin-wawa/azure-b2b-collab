## MDC9292 tenant
#$tenantID = "b4cc3ca2-f9c9-4e2d-8eb8-cb07ee3a7e23"

## Wawa Tenant
#$tenantID = XYZ

$username = $uservariable
$password = $pwdvariable
 
# Create uri and body
$uri = "https://login.microsoftonline.com/{0}/oauth2/token" -f $tenantid
$body = "resource=74658136-14ec-4630-ad9b-26e160ff0fc6&client_id=1950a258-227b-4e31-a9cf-717495945fc2&grant_type=password&username={1}&password={0}" -f [System.Web.HttpUtility]::UrlEncode($password), $username
 
# Request token through ROPC
$token = Invoke-RestMethod $uri -Body $body -ContentType "application/x-www-form-urlencoded" -ErrorAction SilentlyContinue

$b2bPolicy = Invoke-RestMethod 'https://main.iam.ad.ext.azure.com/api/B2B/b2bPolicy' -Headers @{Authorization = "Bearer $($token.access_token)"; "x-ms-client-request-id" = [guid]::NewGuid().ToString(); "x-ms-client-session-id" = [guid]::NewGuid().ToString()}

$b2bPolicy.targetedDomains = Get-Content domains.txt 

# Write the patch