#!/bin/bash

#set -e # Exit script if any statement returns a non-true value.
set -u # Exit script if using an uninitialized variable.

################################################################################
# DEFINES
################################################################################

PATH="$HOME/.cabal/bin:$PATH"
SCRIPT_PATH="../scripts"
LINE="--------------------------------------------------------------------------------"

exit_flag=0


################################################################################
# MAIN
################################################################################

which shellcheck &> /dev/null
if [[ $? -ne 0 ]]; then
	echo "shellcheck is not installed for this user!"
	echo; echo "Install guide can be found here:"
	echo "https://github.com/koalaman/shellcheck"
	echo
	exit 1
else
	shellcheck -V
	echo
fi

SCRIPTS=($(grep "/bin/bash\|/bin/sh" "${SCRIPT_PATH}" -R -l))

for script in "${SCRIPTS[@]}"; do
	if [ -n "${script}" ]; then
		result=$(shellcheck "${script}")
		if [ -n "$result" ]; then
			echo "${LINE}"
			echo "${result}"
			echo "${LINE}"
			exit_flag=1
		else
			echo "${script} OK!"
		fi
		ignore=$(grep -H "# shellcheck disable" "${script}")
		if [ -n "$ignore" ]; then
			echo "${LINE}"
			echo "${ignore}"
			echo "${LINE}"
		fi
	fi
done

exit ${exit_flag}

