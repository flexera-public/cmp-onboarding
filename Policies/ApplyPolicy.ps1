param(
  $FlexeraOrgId = "",
  $FlexeraRefreshToken = "",
  $FlexeraProjectId = "",
  $FlexeraProjectShard = "",
  $CredPrefix = "",
  $PolicyName = "",
  $PolicyFrequency = "",
  $PolicyOptions,
  $PolicyDryRun = $true
  $TerminateExistingPolicy = $true,
  $SkipFirstPolicyVerification = $false
)


function Index-Credentials ($Shard, $AccessToken, $ProjectId) {
  try {
    Write-Output "Indexing credentials in Project ID: $ProjectId..."
    
    $contentType = "application/json"
    
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}
    $uri = "https://cloud-$Shard.rightscale.com/cloud/projects/$ProjectId/credentials"
    Write-Output "URI: $uri"

    $credsResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Get -Headers $header -ContentType $contentType

    return $credsResult
  }
  catch {
      Write-Output "Error retrieving credentials! $($_ | Out-String)" 
  }
}

function Apply-Policy ($Shard, $AccessToken, $ProjectId, $CredId, $FlexeraOrgId, $PolicyName, $Frequency, $Options, $Severity, $TemplateHref, $DryRun) {
  try {
    Write-Output "Creating Policy: $PolicyName"
    Write-Output "in Project ID: $ProjectId"
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}    
    if($CredId) {
      Write-Output "with Credential: $CredId"
      $body = [ordered]@{"description"="Applied via API";"name"="$PolicyName";"frequency"=$Frequency;"credentials"=[ordered]@{"auth_aws"=$CredId};"options"=$Options;"project_ids"=@($ProjectId -as [int]);"severity"=$Severity;"skip_approvals"=$false;"template_href"=$TemplateHref; "dry_run"=$DryRun}
      $body = ConvertTo-Json -Depth 100 -InputObject $body
    }
    else {
      Write-Output "with No Credential"
      $body = [ordered]@{"description"="Applied via API";"name"="$PolicyName";"frequency"=$Frequency;"credentials"=[ordered]@{};"options"=$Options;"project_ids"=@($ProjectId -as [int]);"severity"=$Severity;"skip_approvals"=$false;"template_href"=$TemplateHref; "dry_run"=$DryRun}
      $body = ConvertTo-Json -Depth 100 -InputObject $body
    }

    Write-Verbose $body
    $uri = "https://governance-$shard.rightscale.com/api/governance/org/$FlexeraOrgId/policy_aggregates"
    Write-Output "URI: $uri"

    $createPolicyResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Post -Headers $header -ContentType $contentType -Body $body

    return $createPolicyResult
  }
  catch {
      Write-Output "Error creating policy! $($_ | Out-String)" 
  }
}

function Index-PublishedTemplates ($Shard, $AccessToken, $FlexeraOrgId) {
  try {
    Write-Output "Getting Published Templates in Org ID: $FlexeraOrgId"
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}
    $uri = "https://governance-$Shard.rightscale.com/api/governance/org/$FlexeraOrgId/published_templates"
    Write-Output "URI: $uri"

    $publishedTemplatesResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Get -Headers $header -ContentType $contentType

    return $publishedTemplatesResult
  }
  catch {
    Write-Output "Error getting policy details! $($_ | Out-String)" 
  }
}

function Index-AppliedPolicies ($Shard, $AccessToken, $ProjectId) {
  try {
    Write-Output "Getting Applied Policies in Account ID: $ProjectId"
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}
    $uri = "https://governance-$Shard.rightscale.com/api/governance/projects/$ProjectId/applied_policies"
    Write-Output "URI: $uri"

    $indexAppliedPoliciesResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Get -Headers $header -ContentType $contentType

    return $indexAppliedPoliciesResult
  }
  catch {
    Write-Output "Error getting policy details! $($_ | Out-String)" 
  }
}

function Terminate-AppliedPolicy ($Shard, $AccessToken, $FlexeraOrgId, $AggregateId) {
  try {
    Write-Output "Terminating Policy Aggregate ID '$AggregateId' in Org ID: $FlexeraOrgId"
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}
    $uri = "https://governance-$Shard/api/governance/orgs/$FlexeraOrgId/policy_aggregates/$AggregateId"
    Write-Output "URI: $uri"

    $terminateAppliedPolicyResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Delete -Headers $header -ContentType $contentType

    return $terminateAppliedPolicyResult
  }
  catch {
    Write-Output "Error getting policy details! $($_ | Out-String)" 
  }
}

#Auth
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

if(($null -eq $FlexeraProjectId) -or ($null -eq $FlexeraProjectShard)) {
  Write-Output "FlexeraProjectId or FlexeraProjectShard not supplied. Defaulting to master project..."
  $grsHeader = @{
    "X_API_VERSION" = "2.0";
    "Authorization" = "Bearer $accessToken"
  }
  $grsResponse = Invoke-RestMethod -Uri "https://governance.rightscale.com/grs/orgs/$($FlexeraOrgId)" -Method Get -Headers $grsHeader -ContentType "application/json"
  if ($null -ne $grsResponse) {
    $FlexeraProjectShard = $grsResponse.legacy.account_url.Replace("https://", "").Split(".")[0].Split("-")[1]
    $FlexeraProjectId = $grsResponse.legacy.account_url.Split("/")[-1]
  }
  else {
    Write-Warning "Error retrieving org details"
    EXIT 1
  }
}
else {
  Write-Output "Using supplied FlexeraProjectId and FlexeraProjectShard"
}
Write-Output "Project Id: $FlexeraProjectId"
Write-Output "Project Shard: $FlexeraProjectShard"

#Index Published Templates
$publishedTemplates = Index-PublishedTemplates -AccessToken $accessToken -Shard $Shard -FlexeraOrgId $FlexeraOrgId
$targetTemplate = $publishedTemplates.items | Where-Object name -eq $PolicyName
$Severity = $targetTemplate.Severity
$TemplateHref = $targetTemplate.href 

#Index Applied Policies
$existingAppliedPolicies = Index-AppliedPolicies -ACCESS_TOKEN $accessToken -RS_HOST $RS_HOST -GRS_ACCOUNT $GRS_ACCOUNT -ACCOUNT_ID $ACCOUNT_ID
$targetPolicies = $existingAppliedPolicies.items | Where-Object name -like "*$POLICY_NAME*"

foreach ($cred in $existingCreds) {
  Apply-Policy -AccessToken $accessToken -Shard $Shard -ProjectId $ProjectId -FlexeraOrgId $FlexeraOrgId -Severity $Severity -Frequency $Frequency -CredId $cred.id -PolicyName $PolicyName -TemplateHref $TemplateHref -Options $Options
}

if($POLICY_NAME -like "* - Aggregator") {
  $modified_policyName = $POLICY_NAME
  $existingPolicy = @()
  $existingPolicy = $targetPolicies | Where-Object name -eq $modified_policyName
  $pol_count = ($existingPolicy | Measure-Object).count
  if(($pol_count -gt 0) -and ($TerminateExistingPolicy -eq $false)) {
    Write-Output "Applied Policy with the name '$modified_policyName' already exists (Count: $pol_count)! Skipping..."
    Write-Output $existingPolicy.href
    CONTINUE
  }
  elseif (($pol_count -eq 0) -and ($TerminateExistingPolicy -eq $true)) {
    Write-Output "Applied Policy with the name '$modified_policyName' already exists (Count: $pol_count)! Terminating..."
    foreach($policy in $existingPolicy) {
      Terminate-AppliedPolicy -RS_HOST $RS_HOST -ACCESS_TOKEN $accessToken -GRS_ACCOUNT $GRS_ACCOUNT -AGGREGATE_ID $policy.policy_aggregate_id
    }
  }
  Apply-Policy -AccessToken $accessToken -Shard $FlexeraProjectShard -ProjectId $FlexeraProjectId -FlexeraOrgId $FlexeraOrgId -Severity $severity -Frequency $Frequency -PolicyName $modified_policyName -TemplateHref $template_href -Options $OPTIONS -DryRun $DryRun
}
else {
  #Index Creds
  $existingCreds = (Index-Credentials -AccessToken $accessToken -Shard $FlexeraProjectShard -ProjectId $FlexeraProjectId).items
  $existingCreds = $existingCreds | Where-Object id -Like "$CredPrefix*"
  Write-Output "Identified $($existingCreds.count) credentials to be used."

  foreach ($cred in $existingCreds) {
    if (($cred.id -eq $existingCreds[1].id) -and ($SkipFirstPolicyVerification -eq $false)){
      Write-Output "First Policy has run."
      $continue = Read-Host "Continue? (y/n)"
    }
    elseif ($cred.id -eq $existingCreds[0].id) {
      $continue = "y"
    }

    if ($continue -ne "y") {
      Write-Output "Skipping.."
    }
    else {
      $modified_policyName = "$($cred.id): $POLICY_NAME"
      $existingPolicy = @()
      $existingPolicy = $targetPolicies | Where-Object name -eq $modified_policyName
      if((($existingPolicy| Measure-Object).count -gt 0) -and ($TerminateExistingPolicy -eq $false)) {
        $pol_count = $existingPolicy.count
        Write-Output "Applied Policy with the name '$modified_policyName' already exists (Count: $pol_count)! Skipping..."
        Write-Output $existingPolicy.href
        CONTINUE
      }
      elseif ((($existingPolicy| Measure-Object).count -gt 0) -and ($TerminateExistingPolicy -eq $true)) {
        $pol_count = ($existingPolicy| Measure-Object).count
        Write-Output "Applied Policy with the name '$modified_policyName' already exists (Count: $pol_count)! Terminating..."
        foreach($policy in $existingPolicy) {
          Terminate-AppliedPolicy -Shard $FlexeraProjectShard -AccessToken $accessToken -FlexeraOrgId $FlexeraOrgId -AggregateId $policy.policy_aggregate_id
          Write-Output "Sleeping 5 seconds..."
          Start-Sleep -Seconds 5
        }
      }

      Apply-Policy -AccessToken $accessToken -Shard $FlexeraProjectShard -ProjectId $FlexeraProjectId -FlexeraOrgId $FlexeraOrgId -Severity $severity -Frequency $Frequency -CredId $cred.id -PolicyName $modified_policyName -TemplateHref $template_href -Options $OPTIONS -DryRun $DRY_RUN
      Write-Output "Sleeping 5 seconds..."
      Start-Sleep -Seconds 5
    }
  }
}