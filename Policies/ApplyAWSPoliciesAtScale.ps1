param(
  $FlexeraOrgId,
  $FlexeraRefreshToken,
  [array]$IncidentEmailAddresses = @(),
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

# Policies Currently Defined:
#  AWS Unused Volumes
#  AWS Publicly Accessible RDS Instances
#  AWS Idle Compute Instances
#  AWS Rightsize RDS Instances
#  AWS Long-stopped Instances
#  AWS Delete Unused Classic Load Balancers
#  AWS Inefficient Instance Utilization using CloudWatch
#  AWS S3 Bucket Intelligent Tiering Check
#  AWS GP3 Upgradeable Volumes
#  AWS Unused RDS Instance
#  AWS Unused IP Addresses
#  AWS Old Snapshots
#  AWS Unused ECS Clusters
#  AWS Lambda Functions with high error rate
#  AWS Long Running Instances
#  AWS VPC's without FlowLogs Enabled
#  AWS Unencrypted Volumes
#  AWS Unencrypted RDS Instances
#  AWS Unencrypted ELB Listeners (ALB/NLB)
#  AWS Internet-facing ELBs & ALBs
#  AWS Unencrypted ELB Listeners (CLB)
#  AWS Unencrypted S3 Buckets
#  AWS Open Buckets

# https://github.com/flexera/policy_templates/tree/master/cost/aws/unused_volumes
$policy_name = "AWS Unused Volumes"
$policy_provider = "aws"
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/aws/rds_publicly_accessible
$policy_name = "AWS Publicly Accessible RDS Instances"
$policy_provider = "aws"
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/idle_compute_instances
$policy_name = "AWS Idle Compute Instances"
$policy_provider = "aws"
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
  },
  [ordered]@{
    "name"  = "param_log_to_cm_audit_entries";
    "type"  = "string";
    "value" = "Yes"
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/rds_instance_cloudwatch_utilization
$policy_name = "AWS Rightsize RDS Instances"
$policy_provider = "aws"
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
  },
  [ordered]@{
    "name"  = "param_log_to_cm_audit_entries";
    "type"  = "string";
    "value" = "Yes"
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/compliance/aws/long_stopped_instances
$policy_name = "AWS Long-stopped Instances"
$policy_provider = "aws"
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/elb/clb_unused
$policy_name = "AWS Delete Unused Classic Load Balancers"
$policy_provider = "aws"
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
  },
  [ordered]@{
    "name"  = "param_log_to_cm_audit_entries";
    "type"  = "string";
    "value" = "Yes"
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/instance_cloudwatch_utilization/
$policy_name = "AWS Inefficient Instance Utilization using CloudWatch"
$policy_provider = "aws"
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
  },
  [ordered]@{
    "name"  = "param_log_to_cm_audit_entries";
    "type"  = "string";
    "value" = "Yes"
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/blob/master/cost/aws/s3_storage_policy
$policy_name = "AWS S3 Bucket Intelligent Tiering Check"
$policy_provider = "aws"
$policy_frequency = "weekly"
$policy_options = @(
  [ordered]@{
    "name"  = "param_email";
    "type"  = "list";
    "value" = $IncidentEmailAddresses
  },
  [ordered]@{
    "name"  = "param_exclude_tags";
    "type"  = "list";
    "value" = @("exclude=true")
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/gp3_volume_upgrade
$policy_name = "AWS GP3 Upgradeable Volumes"
$policy_provider = "aws"
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/unused_rds
$policy_name = "AWS Unused RDS Instance"
$policy_provider = "aws"
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/cost/aws/unused_ip_addresses/
$policy_name = "AWS Unused IP Addresses"
$policy_provider = "aws"
$policy_frequency = "weekly"
$policy_options = @(
  [ordered]@{
    "name"  = "param_allowed_regions";
    "type"  = "list";
    "value" = $AWSRegions
  },
  [ordered]@{
    "name"  = "param_exclude_tags";
    "type"  = "list";
    "value" = @("exclude=true")
  },
  [ordered]@{
    "name"  = "param_email";
    "type"  = "list";
    "value" = $IncidentEmailAddresses
  },
  [ordered]@{
    "name"  = "param_automatic_action";
    "type"  = "list";
    "value" = @()
  }
  [ordered]@{
    "name"  = "param_log_to_cm_audit_entries";
    "type"  = "string";
    "value" = "Yes"
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification


# https://github.com/flexera/policy_templates/tree/master/cost/aws/old_snapshots
$policy_name = "AWS Old Snapshots"
$policy_provider = "aws"
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
    "name"  = "snapshot_age";
    "type"  = "number";
    "value" = 30
  },
  [ordered]@{
    "name"  = "param_deregister_image";
    "type"  = "string";
    "value" = "No"
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/compliance/aws/ecs_unused
$policy_name = "AWS Unused ECS Clusters"
$policy_provider = "aws"
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/operational/aws/lambda_functions_with_high_error_rate
$policy_name = "AWS Lambda Functions with high error rate"
$policy_provider = "aws"
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
    "name"  = "param_error_rate";
    "type"  = "number";
    "value" = 10
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/operational/aws/long_running_instances/
$policy_name = "AWS Long Running Instances"
$policy_provider = "aws"
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
    "name"  = "param_days_old";
    "type"  = "number";
    "value" = 180
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/aws/vpcs_without_flow_logs_enabled
$policy_name = "AWS VPC's without FlowLogs Enabled"
$policy_provider = "aws"
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
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/aws/ebs_unencrypted_volumes
$policy_name = "AWS Unencrypted Volumes"
$policy_provider = "aws"
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
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/aws/rds_unencrypted
$policy_name = "AWS Unencrypted RDS Instances"
$policy_provider = "aws"
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/aws/elb_unencrypted
$policy_name = "AWS Unencrypted ELB Listeners (ALB/NLB)"
$policy_provider = "aws"
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
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/aws/loadbalancer_internet_facing
$policy_name = "AWS Internet-facing ELBs & ALBs"
$policy_provider = "aws"
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/aws/clb_unencrypted
$policy_name = "AWS Unencrypted ELB Listeners (CLB)"
$policy_provider = "aws"
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
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/aws/unencrypted_s3_buckets
$policy_name = "AWS Unencrypted S3 Buckets"
$policy_provider = "aws"
$policy_frequency = "weekly"
$policy_options = @(
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
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification

# https://github.com/flexera/policy_templates/tree/master/security/storage/aws/public_buckets
$policy_name = "AWS Open Buckets"
$policy_provider = "aws"
$policy_frequency = "weekly"
$policy_options = @(
  [ordered]@{
    "name"  = "param_email";
    "type"  = "list";
    "value" = $IncidentEmailAddresses
  }
)
./ApplyPolicy.ps1 -FlexeraOrgId $FlexeraOrgId -FlexeraRefreshToken $FlexeraRefreshToken -CredPrefix $CredPrefix -PolicyName $policy_name -PolicyProvider $policy_provider -PolicyFrequency $policy_frequency -PolicyOptions $policy_options -PolicyDryRun $PolicyDryRun -TerminateExistingPolicy $TerminateExistingPolicy -SkipFirstPolicyVerification $SkipFirstPolicyVerification
