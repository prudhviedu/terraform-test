#!/bin/sh
commit_id=$1

for var in terraform packer ansible
do
	git show $commit_id --name-only | grep "^$var/"
	if [ $? -eq 0 ]; then
		echo $var > list_effected_dir.txt
	fi
done
cat list_effected_dir.txt
