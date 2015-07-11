#!/bin/bash

set -e # Exit script if any statement returns a non-true value.
set -u # Exit script if using an uninitialized variable.

################################################################################
# MAIN
################################################################################

(
	cd dummy
	./search.sh penguin
	# Validate
	pid_cnt=$(cat out/pids.txt | wc -l )
	if [[ "$pid_cnt" -eq 7 ]]; then
		echo "PIDs found.. OK"
	else
		echo "PIDs found.. ERROR!"
		exit 1
	fi
	vid_cnt=$(cat out/vids.txt | wc -l )
	if [[ "$vid_cnt" -eq 3 ]]; then
		echo "VIDs found.. OK"
	else
		echo "VIDs found.. ERROR!"
		exit 1
	fi
)


