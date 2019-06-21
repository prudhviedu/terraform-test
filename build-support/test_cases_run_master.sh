#!/bin/sh
aws_profile=$1
aws_region=$2

run_packer() {
	./build-support/run_packer.sh
}

run_terraform() {
	pwd
	echo 'pwd in run_terraform'
	./build-support/run_terraform.sh $1 $2
	if [ $? -ne 0 ]; then
		exit 1
	fi
}

run_ansible() {
	./build-support/run_ansible.sh
}
changes_dir=`sh build-support/check-effected.sh`
echo "changes in $changes_dir"
path='src/terraform'
for var in $changes_dir
do
	pwd
	echo 'pwd in loop'
	if [ "$var" = "packer" ]; then
		echo "running packer"
		run_packer
	elif [ "$var" = "terraform" ]; then
		echo "running terraform"
		run_terraform $aws_profile $aws_region
		if [ $? -ne 0 ]; then
			echo 'Terraform run failed'
			exit 1
		fi
	elif [ "$var" = "ansible" ]; then
		echo "running ansible"
		run_ansible
	else
		echo "no changes in this sha"
	fi
done
