#!/bin/sh
echo "Applying terraform"
cd terraform

export AWS_PROFILE='test-env'
export AWS_REGION='us-east-1'
terraform init
echo 'yes' |terraform apply
terraform output --json > test_cases/terraform_test/files/terraform.json
terraform output --json > test_cases/service_test/files/terraform.json
terraform output > test_cases/endpoint_test/files/terraform.txt
terraform output --json > test_cases/endpoint_test/files/terraform.json
service_ip=`cat test_cases/endpoint_test/files/terraform.txt | grep web_public_ip| cut -d' ' -f3`
inspec exec test_cases/terraform_test -t aws://eu-central-1
inspec exec test_cases/service_test -t ssh://ubuntu@$service_ip -i /home/ubuntu/ec2-key.pem 
sleep 70
inspec exec test_cases/endpoint_test -t ssh://ubuntu@$service_ip -i /home/ubuntu/ec2-key.pem
echo 'yes' |terraform destroy
