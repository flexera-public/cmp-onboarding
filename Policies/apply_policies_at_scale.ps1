param(
  $ACCOUNT_ID,
  $GRS_ACCOUNT,
  $REFRESH_TOKEN
)

$policy_name = "AWS Unused Volumes"
$options = @([ordered]@{"name"="param_email";"type"="list";"value"=@("john.smith@flexera.com", "jane.smith@flexera.com")},[ordered]@{"name"="param_exclude_tags";"type"="list";"value"=@("exclude=true")},[ordered]@{"name"="param_unattached_days";"type"="number";"value"=30},[ordered]@{"name"="param_take_snapshot";"type"="string";"value"="Yes"})
./apply_policy.ps1 -POLICY_NAME $policy_name -REFRESH_TOKEN $REFRESH_TOKEN -ACCOUNT_ID $ACCOUNT_ID -GRS_ACCOUNT $GRS_ACCOUNT -OPTIONS $options -FREQUENCY "weekly"

$policy_name = "AWS Publicly Accessible RDS Instances"
$options = @([ordered]@{"name"="param_email";"type"="list";"value"=@("john.smith@flexera.com", "jane.smith@flexera.com")},[ordered]@{"name"="param_exclude_tags";"type"="list";"value"=@("exclude=true")})
./apply_policy.ps1 -POLICY_NAME $policy_name -REFRESH_TOKEN $REFRESH_TOKEN -ACCOUNT_ID $ACCOUNT_ID -GRS_ACCOUNT $GRS_ACCOUNT -OPTIONS $options -FREQUENCY "weekly"

$policy_name = "AWS Idle Compute Instances"
$options = @([ordered]@{"name"="param_email";"type"="list";"value"=@("john.smith@flexera.com", "jane.smith@flexera.com")},[ordered]@{"name"="param_exclusion_tag_key";"type"="string";"value"="exclude:true"},[ordered]@{"name"="param_avg_used_memory";"type"="number";"value"=10},[ordered]@{"name"="param_avg_cpu";"type"="number";"value"=2})
./apply_policy.ps1 -POLICY_NAME $policy_name -REFRESH_TOKEN $REFRESH_TOKEN -ACCOUNT_ID $ACCOUNT_ID -GRS_ACCOUNT $GRS_ACCOUNT -OPTIONS $options -FREQUENCY "weekly"

$policy_name = "AWS Rightsize RDS Instances"
$options = @([ordered]@{"name"="param_email";"type"="list";"value"=@("john.smith@flexera.com", "jane.smith@flexera.com")},[ordered]@{"name"="param_exclusion_tag_key";"type"="string";"value"="exclude:true"},[ordered]@{"name"="param_avg_cpu_downsize";"type"="number";"value"=60},[ordered]@{"name"="param_avg_cpu_upsize";"type"="number";"value"=80})
./apply_policy.ps1 -POLICY_NAME $policy_name -REFRESH_TOKEN $REFRESH_TOKEN -ACCOUNT_ID $ACCOUNT_ID -GRS_ACCOUNT $GRS_ACCOUNT -OPTIONS $options -FREQUENCY "weekly"

$policy_name = "AWS Long-stopped Instances"
$options = @([ordered]@{"name"="param_email";"type"="list";"value"=@("john.smith@flexera.com", "jane.smith@flexera.com")},[ordered]@{"name"="param_exclude_tags";"type"="list";"value"=@("exclude")},[ordered]@{"name"="param_stopped_days";"type"="number";"value"=30})
./apply_policy.ps1 -POLICY_NAME $policy_name -REFRESH_TOKEN $REFRESH_TOKEN -ACCOUNT_ID $ACCOUNT_ID -GRS_ACCOUNT $GRS_ACCOUNT -OPTIONS $options -FREQUENCY "weekly"

$policy_name = "AWS Delete Unused Classic Load Balancers"
$options = @([ordered]@{"name"="param_email";"type"="list";"value"=@("john.smith@flexera.com", "jane.smith@flexera.com")},[ordered]@{"name"="param_exclude_tags";"type"="list";"value"=@("exclude=true")})
./apply_policy.ps1 -POLICY_NAME $policy_name -REFRESH_TOKEN $REFRESH_TOKEN -ACCOUNT_ID $ACCOUNT_ID -GRS_ACCOUNT $GRS_ACCOUNT -OPTIONS $options -FREQUENCY "weekly"

$policy_name = "AWS Open Buckets"
$options = @([ordered]@{"name"="param_email";"type"="list";"value"=@("john.smith@flexera.com", "jane.smith@flexera.com")},[ordered]@{"name"="param_slack_channel";"type"="string";"value"=""},[ordered]@{"name"="param_slack_webhook_cred";"type"="string";"value"=""})
./apply_policy.ps1 -POLICY_NAME $policy_name -REFRESH_TOKEN $REFRESH_TOKEN -ACCOUNT_ID $ACCOUNT_ID -GRS_ACCOUNT $GRS_ACCOUNT -OPTIONS $options -FREQUENCY "weekly"

