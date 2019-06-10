#!/bin/sh
commit_id=`git rev-parse HEAD`

for var in terraform packer ansible
do
	git show $commit_id --name-only | grep "^$var/" > /dev/null
	if [ $? -eq 0 ]; then
		echo $var
	fi
done
