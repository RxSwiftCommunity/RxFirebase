#!/bin/bash
for pod in $(find . -name "*.podspec" -type f);do
	push=0
	if [[ $1 == 'push' ]]; then
                push=1
        fi
 	if [[ $pod == './RxFirebase.podspec' ]]; then
                if [[ $push == 0 ]]; then
			continue
		fi
        fi
	if [[ $push == 0 ]]; then
		command="pod lib lint $pod --allow-warnings"
	else
		command="pod trunk push $pod --allow-warnings"
	fi
	echo $command
	$command ; result=$?
	if [[ $result != 0 ]]; then
		exit $result
	fi
done
