#!/bin/bash

function pod_lint {
	pod=$1
	command="$pod --allow-warnings"
	if [[ $2 == 0 ]]; then
                command="pod lib lint $command"
        else
                command="pod trunk push $command"
        fi
	echo $command
        $command ; result=$?
}

push=0
if [[ $1 == 'push' ]]; then
	push=1
fi
for pod in $(find . -name "*.podspec" -type f -exec basename {} ';' );do
 	if [[ $pod == 'RxFirebase.podspec' ]]; then
		continue
        fi
	pod_lint $pod $push
	if [[ $result != 0 ]]; then
		exit $result
	fi
done
