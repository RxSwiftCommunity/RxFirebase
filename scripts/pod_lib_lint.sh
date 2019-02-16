for pod in $(find . -name "*.podspec" -type f);do
 	if [[ $pod == '../RxFirebase.podspec' ]]; then
                continue
        fi
	command="pod lib lint $pod --allow-warnings"
	echo $command
	$command ; result=$?
	if [[ $result != 0 ]]; then
		exit $result
	fi
done
