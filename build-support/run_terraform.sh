#!/bin/sh
echo "Applying terraform"
cd terraform/modules

export AWS_PROFILE='test-env'
export AWS_REGION='us-east-1'
terraform init
echo 'yes' |terraform apply
terraform output --json > test_cases/verify/files/terraform.json
inspec exec test_cases/verify -t aws://eu-central-1
echo 'yes' |terraform destroy
#inspec exec test-cases/service_test -t ssh://ubuntu@3.88.11.51 -i /home/ubuntu/ec2-key.pem

