title 'two tier setups'

# load data from terraform output
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

INTANCE_ID = params['instance_id']['value']
VPC_ID = params['vpc_id']['value']
SUBNET_ID_1 = params['subnet_id_1']['value']
SUBNET_ID_2 = params['subnet_id_2']['value']

# execute test
describe aws_vpc(vpc_id: VPC_ID) do
  its('cidr_block') { should cmp '10.10.0.0/16' }
end

describe aws_security_group(group_name: 'terraform_example') do
  it { should exist }
  its('group_name') { should eq 'terraform_example' }
  its('description') { should eq 'Used in the terraform' }
  its('vpc_id') { should eq VPC_ID }  
end

# Examine the security_group in a VPC
describe aws_security_group(group_name: 'terraform_example_elb') do
  it { should exist }
  its('group_name') { should eq 'terraform_example_elb' }
  its('description') { should eq 'Used in the terraform' }
  its('vpc_id') { should eq VPC_ID }  
end

# Examine the ec2_instances 
describe aws_ec2_instance(INTANCE_ID) do
  it { should be_running }
  its('instance_type') { should eq 't2.micro' }
  its('image_id') { should eq 'ami-fa2fb595' }
end

# Examine a specific vpcs Subnet IDs
describe aws_subnet(subnet_id: SUBNET_ID_1 ) do
  it { should exist }
  its('cidr_block') { should eq '10.0.1.0/24' }

end


# Look for an LMF by its filter name and log group name.  This combination
# will always either find at most one LMF - no duplicates.
describe aws_cloudwatch_log_metric_filter(
  filter_name: 'my-filter',
  log_group_name: 'my-log-group'
) do
  it { should exist }
end

# Search for an LMF by pattern and log group.
# This could result in an error if the results are not unique.
describe aws_cloudwatch_log_metric_filter(
  log_group_name:  'my-log-group',
  pattern: 'my-filter'
) do
  it { should exist }
end


# iam groups and users check
describe aws_iam_group('mygroup')
  its('users') { should include 'iam_user_name' }
end

# Verify the route tables
describe aws_route_tables do
  its('vpc_ids') { should include 'vpc_12345678' }
end

describe aws_route_tables do
  its('route_table_ids') { should include 'rtb-12345678' }
end
describe sshd_config do
  its('Ciphers') { should_not match /cbc/ }
end


vpc
subnets
rt_table
vpc_endpoints
cloudwatch
iam groups
dhcp_associations
VPN_gateway
