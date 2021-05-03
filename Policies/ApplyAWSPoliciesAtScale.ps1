param(
  $FlexeraOrgId = "",  
  $FlexeraRefreshToken = "",
  $IncidentEmailAddresses = @(),
  $CredPrefix = "",
  $PolicyDryRun = $true,
  $TerminateExistingPolicy = $true,
  $SkipFirstPolicyVerification = $false,
  $AWSRegions = @(
      "us-east-2",
      "us-east-1",
      "us-west-1",
      "us-west-2",
      "af-south-1",
      "ap-east-1",
      "ap-south-1",
      "ap-northeast-3",
      "ap-northeast-2",
      "ap-southeast-1",
      "ap-southeast-2",
      "ap-northeast-1",
      "ca-central-1",
      "eu-central-1",
      "eu-west-1",
      "eu-west-2",
      "eu-south-1",
      "eu-west-3",
      "eu-north-1",
      "me-south-1",
      "sa-east-1"
    )
)

# https://github.com/flexera/policy_templates/tree/master/cost/aws/unused_volumes
$policy_name = "AWS Unused Volumes"
$policy_frequency = "weekly"
$policy_options = @(
  [ordered]@{
    "name"  = "param_allowed_regions";
    "type"  = "list";
    "value" = $AWSRegions
  },
  [ordered]@{
    "name"  = "param_email";
    "type"  = "list";
    "value" = $IncidentEmailAddresses
  },
  [ordered]@{
    "name"  = "param_exclude_tags";
    "type"  = "list";
    "value" = @("exclude=true")
  },
  [ordered]@{
    "name"  = "param_unattached_days";
    "type"  = "number";
    "value" = 30
  },
  [ordered]@{
    "name"  = "param_take_snapshot";
    "type"  = "string";
    "value" = "Yes"
  },
  [ordered]@{
    "name"  = "param_automatic_action";
    "type"  = "list";
    "value" = @()
  },
  [ordered]@{
    "name"  = "param_flexera_org_id_for_optima";
    "type"  = "string";
    "value" = "current"
  },
  [ordered]@{
    "name"  = "param_log_to_cm_audit_entries";
    "type"  = "string";
    "value" = "Yes"
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/aws/rds_publicly_accessible
$policy_name = "AWS Publicly Accessible RDS Instances"
$policy_frequency = "weekly"
$policy_options = @(
  [ordered]@{
    "name"  = "param_allowed_regions";
    "type"  = "list";
    "value" = $AWSRegions
  },
  [ordered]@{
    "name"  = "param_email";
    "type"  = "list";
    "value" = $IncidentEmailAddresses
  },
  [ordered]@{
    "name"  = "param_exclude_tags";
    "type"  = "list";
    "value" = @("exclude=true")
  },
  [ordered]@{
    "name"  = "param_automatic_action";
    "type"  = "list";
    "value" = @()
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/idle_compute_instances
$policy_name = "AWS Idle Compute Instances"
$policy_frequency = "weekly"
$policy_options = @(
  [ordered]@{
    "name"  = "param_allowed_regions";
    "type"  = "list";
    "value" = $AWSRegions
  },
  [ordered]@{
    "name"  = "param_email";
    "type"  = "list";
    "value" = $IncidentEmailAddresses
  },
  [ordered]@{
    "name"  = "param_avg_used_memory";
    "type"  = "number";
    "value" = -1
  },
  [ordered]@{
    "name"  = "param_avg_cpu";
    "type"  = "number";
    "value" = 5
  },
  [ordered]@{
    "name"  = "param_exclusion_tag_key";
    "type"  = "string";
    "value" = "exclude:true"
  },
  [ordered]@{
    "name"  = "param_automatic_action";
    "type"  = "list";
    "value" = @()
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/rds_instance_cloudwatch_utilization
$policy_name = "AWS Rightsize RDS Instances"
$policy_frequency = "weekly"
$policy_options = @(
  [ordered]@{
    "name"  = "param_allowed_regions";
    "type"  = "list";
    "value" = $AWSRegions
  },
  [ordered]@{
    "name"  = "param_email";
    "type"  = "list";
    "value" = $IncidentEmailAddresses
  },
  [ordered]@{
    "name"  = "param_avg_cpu_upsize";
    "type"  = "number";
    "value" = 80
  },
  [ordered]@{
    "name"  = "param_avg_cpu_downsize";
    "type"  = "number";
    "value" = 60
  },
  [ordered]@{
    "name"  = "param_exclusion_tag_key";
    "type"  = "string";
    "value" = "exclude:true"
  },
  [ordered]@{
    "name"  = "param_automatic_action";
    "type"  = "list";
    "value" = @()
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/compliance/azure/azure_long_stopped_instances
$policy_name = "AWS Long stopped Instances"
$policy_frequency = "weekly"
$policy_options = @(
  [ordered]@{
    "name"  = "param_allowed_regions";
    "type"  = "list";
    "value" = $AWSRegions
  },
  [ordered]@{
    "name"  = "param_email";
    "type"  = "list";
    "value" = $IncidentEmailAddresses
  },
  [ordered]@{
    "name"  = "param_exclude_tags";
    "type"  = "list";
    "value" = @("exclude:true")
  },
  [ordered]@{
    "name"  = "param_stopped_days";
    "type"  = "number";
    "value" = 30
  },
  [ordered]@{
    "name"  = "param_automatic_action";
    "type"  = "list";
    "value" = @()
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/elb/clb_unused
$policy_name = "AWS Delete Unused Classic Load Balancers"
$policy_frequency = "weekly"
$policy_options = @(
  [ordered]@{
    "name"  = "param_allowed_regions";
    "type"  = "list";
    "value" = $AWSRegions
  },
  [ordered]@{
    "name"  = "param_email";
    "type"  = "list";
    "value" = $IncidentEmailAddresses
  },
  [ordered]@{
    "name"  = "param_exclude_tags";
    "type"  = "list";
    "value" = @("exclude=true")
  },
  [ordered]@{
    "name"  = "param_automatic_action";
    "type"  = "list";
    "value" = @()
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification
