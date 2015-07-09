#!/bin/bash

set -e # Exit script if any statement returns a non-true value.
set -u # Exit script if using an uninitialized variable.

################################################################################
# DEFINES
################################################################################

INPUT=""

OUT_DIR="../out"
ID_OUT="${OUT_DIR}/ids.txt"
VID_OUT="${OUT_DIR}/vids.txt"
PID_OUT="${OUT_DIR}/pids.txt"
VID_MISSING="${OUT_DIR}/vids_missing.txt"
PID_MISSING="${OUT_DIR}/pids_missing.txt"

VERIFIED_DIR="../verified"
VID_VERIFIED="${VERIFIED_DIR}/vid_defines.txt"
PID_VERIFIED="${VERIFIED_DIR}/pid_defines.txt"


################################################################################
# MAIN
################################################################################

if [[ "$#" -ne 1 ]]; then
	echo "Usage $0 SOURCE"
	echo "Where SOURCE is a git clone of the Linux kernel source."
	exit 1
else
	INPUT=$1
fi


if [[ -d "$INPUT" ]]; then
	mkdir -p "${OUT_DIR}"
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

cp "${VID_OUT}" "${VID_MISSING}"
while read define; do
	if [[ -n "${define}" ]]; then
		sed -i "/$define/d" "${VID_MISSING}"
	fi
done < "${VID_VERIFIED}"

cp "${PID_OUT}" "${PID_MISSING}"
while read define; do
	if [[ -n "${define}" ]]; then
		sed -i "/$define/d" "${PID_MISSING}"
	fi
done < "${PID_VERIFIED}"


