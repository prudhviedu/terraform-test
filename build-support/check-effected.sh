#!/bin/sh
commit_id=$1

for var in terraform packer ansible
	git show $commit_id --name-only | grep "^$var/"
	if [ $? -eq 0 ]; then
		echo $var > build-support/list_effected_dir.txt
	fi
cat build-support/list_effected_dir.txt
