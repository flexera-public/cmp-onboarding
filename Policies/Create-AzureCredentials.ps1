$clientid = ""
$tenantid = ""
$clientsecret = ""
$accountId = ""
$refreshToken = ""

function New-AzureCredential ($shard, $accountId, $accessToken, $name, $description, $resource, $tenantid, $clientid, $clientsecret, $tagProvider, $tagUi) {

try {
    Write-Output "Creating credentials in Project ID: $accountId..."
    
    $contentType = "application/json"
    $header = @{"Api-Version"="1.0";"Authorization"="Bearer $accessToken"}
    $body = [ordered]@{
        "description"=$description;
        "name"=$name;
        "grant_type"= "client_credentials";
        "token_url"= "https://login.windows.net/$($tenantid)/oauth2/token";
        "client_credentials_params"=@{
            "additional_params"=@{
                "resource"=$resource
            }
            "client_id"=@{
                "type"= "plain";
                "data"= $clientid;
            }
            "client_secret"=@{
                "type"="plain";
                "data"=$clientsecret;
            }
        }
        "tags"=@(
            [ordered]@{
            "key"="provider";
            "value"=$tagProvider
            };
            [ordered]@{
                "key"="ui";
                "value"=$tagUi
            }
        )
    } | ConvertTo-Json
    Write-Output "URI: https://cloud-$shard.rightscale.com/cloud/projects/$accountId/credentials/oauth2/$name"

    $putCredResult = Invoke-RestMethod -UseBasicParsing -Uri "https://cloud-$shard.rightscale.com/cloud/projects/$accountId/credentials/oauth2/$name" -Method Put -Headers $header -ContentType $contentType -Body $body

    return $putCredResult
  }
  catch {
      Write-Output "Error creating credential! $($_ | Out-String)" 
  }

}

#Auth
$contentType = "application/json"
$oauthHeader = @{"X_API_VERSION"="1.5"}
$oauthBody = @{"grant_type"="refresh_token";"refresh_token"=$refreshToken} | ConvertTo-Json
try{
    $rsHost = "us-3.rightscale.com"
    $shard = $rsHost.split('.')[0].split('-')[-1]
    $oauthResult = Invoke-WebRequest -Uri "https://$rsHost/api/oauth2" -Method Post -Headers $oauthHeader -ContentType $contentType -Body $oauthBody -MaximumRedirection 0
    $accessToken = ($oauthResult.content | ConvertFrom-Json).access_token
}
catch{
    Write-Output "Redirected"
    # Request is redirected if the incorrect endpoint is used
    $rsHost = "us-4.rightscale.com"
    $shard = $rsHost.split('.')[0].split('-')[-1]
    $oauthResult = Invoke-WebRequest -Uri "https://$rsHost/api/oauth2"  -Method Post -Headers $oauthHeader -ContentType $contentType -Body $oauthBody -MaximumRedirection 0
    $accessToken = ($oauthResult.content | ConvertFrom-Json).access_token
}


# ARM - Resource Manager API
$tagProvider = "azure_rm"
$tagUi = "azure_rm"
$resource = "https://management.azure.com"
$credname = "TestCred-ARM"
$credDescription = $credname
New-AzureCredential -shard $shard -accountId $accountId -accessToken $accessToken -name $credname -description $credDescription -resource $resource -tenantid $tenantid -clientid $clientid -clientsecret $clientsecret -tagProvider $tagProvider -tagUi $tagUi

# ARM - Log Analytics
$tagProvider = "azure_log"
$tagUi = "azure_rm"
$resource = "https://api.loganalytics.io"
$credname = "TestCred-LA"
$credDescription = $credname
New-AzureCredential -shard $shard -accountId $accountId -accessToken $accessToken -name $credname -description $credDescription -resource $resource -tenantid $tenantid -clientid $clientid -clientsecret $clientsecret -tagProvider $tagProvider -tagUi $tagUi

# ARM - AzureAD
$tagProvider = "azure_graph"
$tagUi = "azure_rm"
$resource = "https://graph.microsoft.com"
$credname = "TestCred-AAD"
$credDescription = $credname
New-AzureCredential -shard $shard -accountId $accountId -accessToken $accessToken -name $credname -description $credDescription -resource $resource -tenantid $tenantid -clientid $clientid -clientsecret $clientsecret -tagProvider $tagProvider -tagUi $tagUi