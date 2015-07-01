#!/bin/bash

set -u # exit if an uninitialized variable is used
set -e # exit if any statement returns a non-true value

OUT_DIR="../out"
ID_OUT="${OUT_DIR}/ids.txt"
VID_OUT="${OUT_DIR}/vids.txt"
PID_OUT="${OUT_DIR}/pids.txt"


if [[ "$#" -ne 1 ]]; then
	echo "Usage $0 SOURCE"
	echo "Where SOURCE is a git clone of the Linux kernel source."
	exit 1
else
	INPUT=$1
fi


if [[ -d "$INPUT" ]]; then
	# Locate C #defines with at least a 2-byte hex value
	grep "define" "${INPUT}" -R | grep -E "0x[a-fA-F0-9]{4}" > ${ID_OUT}
	# Locate USB Vendor ID define candidates
	grep "VID" < ${ID_OUT} > ${VID_OUT}
	# Locate USB Product ID define candidates
	grep "PID" < ${ID_OUT} > ${PID_OUT}
	# Print statistics
	vid_cnt=$(wc -l < ${VID_OUT})
	pid_cnt=$(wc -l < ${PID_OUT})
	echo "Found ${vid_cnt} VIDs and ${pid_cnt} PIDs that should be evaluated."
fi

