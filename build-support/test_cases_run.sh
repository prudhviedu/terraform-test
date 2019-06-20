#!/bin/sh
git_branch=$1
git_commit=$2
aws_profile=$3
aws_region=$4

run_packer() {
	sh build-support/run_packer.sh
}

run_terraform() {
	sh build-support/run_terraform.sh 
}

run_ansible() {
	sh build-support/run_ansible.sh
}
changes_dir=`sh build-support/check-effected.sh`
echo "changes in $changes_dir"
for var in $changes_dir
do
	if [ "$git_branch" != "master" -a "$var" = "packer" ]; then
		echo "running packer"
		run_packer
	elif [ "$git_branch" != "master" -a "$var" = "terraform" ]; then
		echo "running terraform"
		run_terraform 'src/terraform' $aws_profile $aws_region
	elif [ "$git_branch" != "master" -a "$var" = "ansible" ]; then
		echo "running ansible"
		run_ansible
	else
		echo "no changes in this sha"
	fi
done
