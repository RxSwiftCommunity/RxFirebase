#!/bin/bash
for pod in $(find . -name "*.podspec" -type f -exec basename {} ';' );do
	push=0
	if [[ $1 == 'push' ]]; then
                push=1
        fi
 	if [[ $pod == 'RxFirebase.podspec' ]]; then
			continue
        fi
	if [[ $push == 0 ]]; then
		command="pod lib lint $pod --allow-warnings --verbose"
	else
		command="pod trunk push $pod --allow-warnings  --verbose"
	fi
	echo $command
	$command ; result=$?
	if [[ $result != 0 ]]; then
		exit $result
	fi
done
