param(
  $FlexeraOrgId,
  $FlexeraRefreshToken,
  $FlexeraProjectId,
  $FlexeraProjectShard,
  $CredPrefix = "",
  $PolicyName,
  $PolicyProvider,
  $PolicyFrequency,
  $PolicyOptions,
  $PolicyDryRun = $true,
  $TerminateExistingPolicy = $true,
  $SkipFirstPolicyVerification = $false
)

function Index-Credentials ($Shard, $AccessToken, $ProjectId, $PolicyProvider) {
  try {
    $credsResultFiltered = @()
    Write-Verbose "Indexing credentials in Project ID: $ProjectId..."
    
    $contentType = "application/json"
    
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}
    
    $uri = "https://cloud-$Shard.rightscale.com/cloud/projects/$ProjectId/credentials"
    Write-Verbose "URI: $uri"

    $credsResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Get -Headers $header -ContentType $contentType
    if($PolicyProvider) {
      foreach($cred in $credsResult.items) {
        $tags = $cred.tags
        foreach($tag in $tags) {
          if(($tag.key -eq "provider") -and ($tag.value -eq $PolicyProvider)) {
            $credsResultFiltered += $cred
            CONTINUE
          }
        }
      }
    }
    else {
      $credsResultFiltered = $credsResult.items
    }

    return $credsResultFiltered
  }
  catch {
      Write-Warning "Error retrieving credentials! $($_ | Out-String)" 
  }
}

function Apply-Policy ($Shard, $AccessToken, $FlexeraProjectId, $CredId, $FlexeraOrgId, $PolicyName, $Frequency, $Options, $Severity, $TemplateHref, $DryRun) {
  try {
    Write-Verbose "Creating Policy: $PolicyName"
    Write-Verbose "in Project ID: $FlexeraProjectId"
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}    
    if($CredId) {
      Write-Verbose "with Credential: $CredId"
      $body = [ordered]@{"description"="Applied via API";"name"="$PolicyName";"frequency"=$Frequency;"credentials"=[ordered]@{"auth_aws"=$CredId};"options"=$Options;"project_ids"=@($FlexeraProjectId -as [int]);"severity"=$Severity;"skip_approvals"=$false;"template_href"=$TemplateHref; "dry_run"=$DryRun}
      $body = ConvertTo-Json -Depth 100 -InputObject $body
    }
    else {
      Write-Verbose "with No Credential"
      $body = [ordered]@{"description"="Applied via API";"name"="$PolicyName";"frequency"=$Frequency;"credentials"=[ordered]@{};"options"=$Options;"project_ids"=@($FlexeraProjectId -as [int]);"severity"=$Severity;"skip_approvals"=$false;"template_href"=$TemplateHref; "dry_run"=$DryRun}
      $body = ConvertTo-Json -Depth 100 -InputObject $body
    }

    $uri = "https://governance-$Shard.rightscale.com/api/governance/orgs/$FlexeraOrgId/policy_aggregates"
    Write-Verbose "URI: $uri"

    $createPolicyResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Post -Headers $header -ContentType $contentType -Body $body

    return $true
  }
  catch {
      Write-Warning "Error creating policy! $($_ | Out-String)" 
  }
}

function Index-PublishedTemplates ($Shard, $AccessToken, $FlexeraOrgId) {
  try {
    Write-Verbose "Getting Published Templates in Org ID: $FlexeraOrgId"
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}
    $uri = "https://governance-$Shard.rightscale.com/api/governance/orgs/$FlexeraOrgId/published_templates"
    Write-Verbose "URI: $uri"

    $publishedTemplatesResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Get -Headers $header -ContentType $contentType

    return $publishedTemplatesResult
  }
  catch {
    Write-Warning "Error getting policy details! $($_ | Out-String)" 
  }
}

function Index-AppliedPolicies ($Shard, $AccessToken, $FlexeraProjectId) {
  try {
    Write-Verbose "Getting Applied Policies in Account ID: $FlexeraProjectId"
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}
    $uri = "https://governance-$Shard.rightscale.com/api/governance/projects/$FlexeraProjectId/applied_policies"
    Write-Verbose "URI: $uri"

    $indexAppliedPoliciesResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Get -Headers $header -ContentType $contentType

    return $indexAppliedPoliciesResult
  }
  catch {
    Write-Warning "Error getting policy details! $($_ | Out-String)" 
  }
}

function Terminate-AppliedPolicy ($Shard, $AccessToken, $FlexeraOrgId, $AggregateId) {
  try {
    Write-Verbose "Terminating Policy Aggregate ID '$AggregateId' in Org ID: $FlexeraOrgId"
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $AccessToken"}
    $uri = "https://governance-$Shard.rightscale.com/api/governance/orgs/$FlexeraOrgId/policy_aggregates/$AggregateId"
    Write-Verbose "URI: $uri"

    $terminateAppliedPolicyResult = Invoke-RestMethod -UseBasicParsing -Uri $uri -Method Delete -Headers $header -ContentType $contentType

    return $terminateAppliedPolicyResult
  }
  catch {
    Write-Warning "Error terminating policy! $($_ | Out-String)" 
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
  Write-Host "Successfully retrieved access token"
  $accessToken = $oauthResponse.access_token
}
else {
  Write-Host "Failed to retrieve access token"
}

if(($null -eq $FlexeraProjectId) -or ($null -eq $FlexeraProjectShard)) {
  Write-Host "FlexeraProjectId or FlexeraProjectShard not supplied. Defaulting to master project..."
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
  Write-Host "Using supplied FlexeraProjectId and FlexeraProjectShard"
}
Write-Host "Project Id: $FlexeraProjectId"
Write-Host "Project Shard: $FlexeraProjectShard"

#Index Published Templates
$publishedTemplates = Index-PublishedTemplates -Shard $FlexeraProjectShard -AccessToken $accessToken -FlexeraOrgId $FlexeraOrgId
$targetTemplate = $publishedTemplates.items | Where-Object name -eq $PolicyName
$Severity = $targetTemplate.Severity
$TemplateHref = $targetTemplate.href

#Index Applied Policies
$existingAppliedPolicies = Index-AppliedPolicies -Shard $FlexeraProjectShard -AccessToken $accessToken -FlexeraProjectId $FlexeraProjectId
$targetPolicies = $existingAppliedPolicies.items | Where-Object name -like "*$PolicyName*"

if($PolicyName -like "* - Aggregator") {
  $modified_policyName = $PolicyName
  $existingPolicy = @()
  $existingPolicy = $targetPolicies | Where-Object name -eq $modified_policyName
  $pol_count = ($existingPolicy | Measure-Object).count
  if(($pol_count -gt 0) -and ($TerminateExistingPolicy -eq $false)) {
    Write-Host "Applied Policy with the name '$modified_policyName' already exists (Count: $pol_count)! Skipping..."
    Write-Host $existingPolicy.href
    CONTINUE
  }
  elseif (($pol_count -eq 0) -and ($TerminateExistingPolicy -eq $true)) {
    Write-Host "Applied Policy with the name '$modified_policyName' already exists (Count: $pol_count)! Terminating..."
    foreach($policy in $existingPolicy) {
      Terminate-AppliedPolicy -Shard $FlexeraProjectShard -AccessToken $accessToken -FlexeraOrgId $FlexeraOrgId -AggregateId $policy.policy_aggregate_id
    }
  }
  $policyResult = Apply-Policy -Shard $FlexeraProjectShard -AccessToken $accessToken -FlexeraProjectId $FlexeraProjectId -FlexeraOrgId $FlexeraOrgId -Severity $Severity -Frequency $PolicyFrequency -PolicyName $modified_policyName -TemplateHref $TemplateHref -Options $PolicyOptions -DryRun $DryRun
}
else {
  #Index Creds
  $existingCreds = Index-Credentials -AccessToken $accessToken -Shard $FlexeraProjectShard -ProjectId $FlexeraProjectId -PolicyProvider $PolicyProvider
  $existingCreds = $existingCreds | Where-Object id -Like "$CredPrefix*"

  foreach ($cred in $existingCreds) {
    if (($cred.id -eq $existingCreds[1].id) -and ($SkipFirstPolicyVerification -eq $false)){
      Write-Host "First Policy has run."
      $continue = Read-Host "Continue? (y/n)"
    }
    elseif ($cred.id -eq $existingCreds[0].id) {
      $continue = "y"
    }

    if ($continue -ne "y") {
      Write-Host "Skipping.."
    }
    else {
      $modified_policyName = "$($cred.id): $PolicyName"
      $existingPolicy = @()
      $existingPolicy = $targetPolicies | Where-Object name -eq $modified_policyName
      if((($existingPolicy| Measure-Object).count -gt 0) -and ($TerminateExistingPolicy -eq $false)) {
        $pol_count = $existingPolicy.count
        Write-Host "Applied Policy with the name '$modified_policyName' already exists (Count: $pol_count)! Skipping..."
        Write-Host $existingPolicy.href
        CONTINUE
      }
      elseif ((($existingPolicy| Measure-Object).count -gt 0) -and ($TerminateExistingPolicy -eq $true)) {
        $pol_count = ($existingPolicy| Measure-Object).count
        Write-Host "Applied Policy with the name '$modified_policyName' already exists (Count: $pol_count)! Terminating..."
        foreach($policy in $existingPolicy) {
          $policyResult = Terminate-AppliedPolicy -Shard $FlexeraProjectShard -AccessToken $accessToken -FlexeraOrgId $FlexeraOrgId -AggregateId $policy.policy_aggregate_id
          Write-Host "Sleeping 5 seconds..."
          Start-Sleep -Seconds 1
        }
      }

      $policyResult = Apply-Policy -Shard $FlexeraProjectShard -AccessToken $accessToken -FlexeraProjectId $FlexeraProjectId -FlexeraOrgId $FlexeraOrgId -Severity $severity -Frequency $PolicyFrequency -CredId $cred.id -PolicyName $modified_policyName -TemplateHref $TemplateHref -Options $PolicyOptions -DryRun $PolicyDryRun
      Write-Host "Sleeping 5 seconds..."
      Start-Sleep -Seconds 1
    }
  }
}