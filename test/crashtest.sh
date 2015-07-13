#!/bin/bash

set -e # Exit script if any statement returns a non-true value.
set -u # Exit script if using an uninitialized variable.

################################################################################
# Expected test output
################################################################################
# Searching for possible USB IDs...
# Found 4 VIDs, 7 PIDs and 0 VID/PIDs that should be evaluated.
# Warning! Unable to located (verified ID: FTDI_232J_PID)
#
# Vendor ID status:
# 	Progress: 25.00% (1/4)
#
# Product ID status:
# 	Progress: 0% (0/7)
#
# Vendor and/or Product ID status:
# 	Progress: 100.00% (0/0)
#
# Complete...
#
# PIDs found.. OK
# VIDs found.. OK


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
	if [[ "$vid_cnt" -eq 4 ]]; then
		echo "VIDs found.. OK"
	else
		echo "VIDs found.. ERROR!"
		exit 1
	fi
)


