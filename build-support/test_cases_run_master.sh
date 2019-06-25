#!/bin/bash
git_branch=$1
git_commit=$2
aws_profile=$3
aws_region=$4

run_packer() {
	./build-support/run_packer.sh
}

run_terraform() {
	pwd
	echo 'pwd in run_terraform'
	./build-support/run_terraform.sh $2 $3
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
	if [ "$git_branch" != "master" -a "$var" = "packer" ]; then
		echo "running packer"
		run_packer
	elif [ "$git_branch" != "master" -a "$var" = "terraform" ]; then
		echo "running terraform"
		run_terraform $aws_profile $aws_region
		if [ $? -ne 0 ]; then
			echo 'Terraform run failed'
			exit 1
		fi
	elif [ "$git_branch" != "master" -a "$var" = "ansible" ]; then
		echo "running ansible"
		run_ansible
	else
		echo "no changes in this sha"
	fi
done
