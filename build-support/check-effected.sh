#!/bin/sh
commit_id=`git rev-parse HEAD`
git show $commit_id --name-only > files_list
while read var
do
	echo $var | grep -E  "^src/terraform|^src/packer|^src/ansible" > /dev/null
	if [ $? -eq 0 ]; then
		echo $var | rev |cut -d '/' -f 2- | rev >> changed_dir.txt
	fi
done < files_list
cat changed_dir.txt | uniq
rm -rf changed_dir.txt files_list
