param(
  $FlexeraOrgId = "",  
  $FlexeraRefreshToken = "",
  $CSV = "" # Script expects 2 columns, Name and ARN.
)
function Index-Credentials ($Shard, $AccessToken, $ProjectId) {
  try {
    Write-Output "Indexing credentials in Project ID: $ProjectId..."

    $contentType = "application/json"

    $header = @{
      "Api-Version"   = "1.0";
      "Authorization" = "Bearer $AccessToken"
    }
    $uri = "https://cloud-$shard.rightscale.com/cloud/projects/$ProjectId/credentials?scheme=aws_sts"
    Write-Output "URI: $uri"

    $credsResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Get -Headers $header -ContentType $contentType

    return $credsResult
  }
  catch {
    Write-Output "Error retrieving credentials! $($_ | Out-String)"
  }
}

function Show-Credential ($Shard, $AccessToken, $ProjectId, $CredentialId) {
  try {
    Write-Output "Showing credential $CredentialId in Project ID: $ProjectId..."

    $contentType = "application/json"

    $header = @{
      "Api-Version"   = "1.0";
      "Authorization" = "Bearer $AccessToken"
    }
    $uri = "https://cloud-$shard.rightscale.com/cloud/projects/$ProjectId/credentials/aws_sts/$CredentialId"
    Write-Output "URI: $uri"

    $credsResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Get -Headers $header -ContentType $contentType

    return $credsResult
  }
  catch {
    Write-Output "Error retrieving credentials! $($_ | Out-String)"
  }
}

function Create-AWSSTSCredential ($Shard, $AccessToken, $ProjectId, $Name, $Id, $Description, $ExternalId, $RoleARN) {
  try {
    Write-Output "Creating credential $Name in Project ID: $ProjectId..."
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}
    $body = [ordered]@{"description"=$Description;"external_id"=$ExternalId;"name"=$Name;"role_arn"=$RoleARN;"role_session_name"="flexera-policies";"tags"=@([ordered]@{"key"="provider";"value"="aws"};[ordered]@{"key"="ui";"value"="aws_sts"})} | ConvertTo-Json
    $uri = "https://cloud-$Shard.rightscale.com/cloud/projects/$ProjectId/credentials/aws_sts/$Id"
    Write-Output "URI: $uri"
    $putCredResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Put -Headers $header -ContentType $contentType -Body $body
    Write-Output "Successfully created credential!"
    return $putCredResult
  }
  catch {
      Write-Output "Error creating credential! $($_ | Out-String)" 
  }
}

$oauthUri = "https://login.flexera.com/oidc/token"
$oauthBody = @{
  "grant_type"    = "refresh_token";
  "refresh_token" = $FlexeraRefreshToken
} | ConvertTo-Json
$oauthResponse = Invoke-RestMethod -Method Post -Uri $oauthUri -Body $oauthBody -ContentType "application/json"
if (-not($null -eq $oauthResponse.access_token)) {
  Write-Output "Successfully retrieved access token"
  $accessToken = $oauthResponse.access_token
}
else {
  Write-Output "Failed to retrieve access token"
}

# Get Master Account Id
$grsHeader = @{
  "X_API_VERSION" = "2.0";
  "Authorization" = "Bearer $accessToken"
}
$grsResponse = Invoke-RestMethod -Uri "https://governance.rightscale.com/grs/orgs/$($FlexeraOrgId)" -Method Get -Headers $grsHeader -ContentType "application/json"
if ($null -ne $grsResponse) {
  $shard = $grsResponse.legacy.account_url.Replace("https://", "").Split(".")[0].Split("-")[1]
  $masterAccount = $grsResponse.legacy.account_url.Split("/")[-1]
  Write-Output "Shard: $shard"
  Write-Output "Master Account Id: $masterAccount"
}
else {
  Write-Output "Error retrieveing org details"
  EXIT 1
}

$existingCreds = Index-Credentials -AccessToken $accessToken -Shard $shard -ProjectId $masterAccount
if ($existingCreds.count -gt 0) {
  $awsCreds = @()
  foreach ($cred in $existingCreds.items) {
    $awsCreds += Show-Credential -ProjectId $masterAccount -AccessToken $accessToken -Shard $shard -CredentialId $cred.id
  }
}

if (Test-Path -Path $CSV) {
  $awsRoleARNs = Import-Csv -Path $CSV
  if (($awsRoleARNs | Get-Member -MemberType NoteProperty).Name -notcontains "Name" -and "ARN") {
    Write-Warning "CSV does not contain 'Name' and/or 'ARN' columns"
  }
  else {
    foreach ($item in $awsRoleARNs) {
      Write-Output "Name: $($item.name) | ARN: $($item.arn)"
      if (-not($awsCreds.role_arn -contains $item.arn)) {
        Write-Output "Credential does not exist. Creating..."
        $credId = "AWS_$($item.name)"
        $credResponse = Create-AWSSTSCredential -Shard $shard -AccessToken $accessToken -ProjectId $masterAccount -Name $credId -Id $credId -Description "Created via Onboarding Script" -ExternalId $FlexeraOrgId -RoleARN $item.arn
      }
      else {
        Write-Output "Credential already exists. Skipping..."
      }
    }
  }
}
else {
  Write-Warning "CSV not found @ $CSV"
}