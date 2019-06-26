#!/bin/sh
git_branch=$1
git_commit=$2
aws_profile=$3
aws_region=$4

run_packer() {
	./build-support/run_packer.sh $1
        if [ $? -ne 0 ]; then
		echo "Failed executing packer in code $1"
                exit 1
        fi
}

run_terraform() {
	./build-support/run_terraform.sh "$1" "$2" "$3"
	if [ $? -ne 0 ]; then
		echo "Failed executing terraform in code $3"
		exit 1
	fi
}

run_ansible() {
	./build-support/run_ansible.sh $1
        if [ $? -ne 0 ]; then
                echo "Failed executing ansible in code $1"
                exit 1
        fi
}
if [ "$#" -eq 4 ]; then
        aws_profile=$3
        aws_region=$4
else
        aws_profile='test-env'
        aws_region='us-east-1'
fi
if [ "$git_branch" = "master" ]; then
	echo "changed in master branch... skipping the build right away"
	exit 0
fi
sh ./build-support/check-effected.sh > ./build-support/changed_directories.txt
check=`cat ./build-support/changed_directories.txt | wc -l`
if [ $check -eq 0 ]; then
	echo "No changed in Packer, Terraform and Ansible code"
else
	while read changes_dir
	do
		echo $changes_dir | grep "^src/packer" >> /dev/null
		if [ $? -eq 0 ]; then
			echo "running packer $changes_dir"
			run_packer "$changes_dir"
			run_terraform $aws_profile $aws_region "$changes_dir"
                        if [ $? -ne 0 ]; then
                                echo 'Terraform run failed'
                                exit 1  
                        fi
			run_ansible "$changes_dir"
		fi
		echo $changes_dir | grep "^src/terraform" >> /dev/null
		if [ $? -eq 0 ]; then
			echo "running terraform in $changes_dir"
			run_terraform $aws_profile $aws_region "$changes_dir"
			if [ $? -ne 0 ]; then
				echo 'Terraform run failed'
				exit 1
			fi
			run_ansible "$changes_dir"
		fi
		echo $changes_dir | grep "^src/ansible" >> /dev/null
		if [ "$var" = "ansible" ]; then
			echo "running ansible in $changes_dir"
			run_ansible "$changes_dir"
		fi
	done < ./build-support/changed_directories.txt
fi
