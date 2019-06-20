#!/bin/sh
if [ "$#" -eq 3 ]; then
	export AWS_PROFILE=$1
	export AWS_REGION=$2
else
	export AWS_REGION='us-east-1'
	export AWS_PROFILE='test-env'
fi
echo "Applying terraform"
#path="$1"
cd src/terraform
pwd
terraform init
echo 'yes' |terraform apply
if [ $? -ne 0 ]; then
	echo 'Failed to run terraform apply'
	exit 1
else
	mkdir -p test_cases/terraform_test/files
	mkdir -p test_cases/service_test/files
	mkdir -p test_cases/endpoint_test/files
	terraform output --json > test_cases/terraform_test/files/terraform.json
	terraform output --json > test_cases/service_test/files/terraform.json
	terraform output > test_cases/endpoint_test/files/terraform.txt
	terraform output --json > test_cases/endpoint_test/files/terraform.json
	service_ip=`cat test_cases/endpoint_test/files/terraform.txt | grep web_public_ip| cut -d' ' -f3`
	inspec exec test_cases/terraform_test -t aws://eu-central-1
	if [ $? -ne 0 ]; then
		echo "terraform_test case failed"
		exit 1
	fi
	
	inspec exec test_cases/service_test -t ssh://ubuntu@$service_ip -i /home/ubuntu/ec2-key.pem 
        if [ $? -ne 0 ]; then
                echo "service_test case failed"
                exit 1
        fi
	sleep 70
	inspec exec test_cases/endpoint_test -t ssh://ubuntu@$service_ip -i /home/ubuntu/ec2-key.pem
	if [ $? -ne 0 ]; then
                echo "endpoint_test case failed"
                exit 1
        fi
	echo 'yes' |terraform destroy
        if [ $? -ne 0 ]; then
                echo "terraform destroy failed, please cleanup the resources"
                exit 1
        fi
fi
