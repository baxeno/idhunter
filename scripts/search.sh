#!/bin/bash

set -e # Exit script if any statement returns a non-true value.
set -u # Exit script if using an uninitialized variable.

################################################################################
# DEFINES
################################################################################

INPUT=""

OUT_DIR="./out"
ID_OUT="${OUT_DIR}/ids.txt"
VID_OUT="${OUT_DIR}/vids.txt"
PID_OUT="${OUT_DIR}/pids.txt"
VID_MISSING="${OUT_DIR}/vids_missing.txt"
PID_MISSING="${OUT_DIR}/pids_missing.txt"

VERIFIED_DIR="./verified"
VID_VERIFIED="${VERIFIED_DIR}/vid_defines.txt"
PID_VERIFIED="${VERIFIED_DIR}/pid_defines.txt"


################################################################################
# MAIN
################################################################################

if [[ "$#" -ne 1 ]]; then
	echo "Usage $0 SOURCE"
	echo "SOURCE is a git clone of the Linux kernel source."
	echo "Output will be stored in working directory."
	exit 1
else
	INPUT=$1
fi


if [[ -d "$INPUT" ]]; then
	mkdir -p "${OUT_DIR}"
	mkdir -p "${VERIFIED_DIR}"
	# Locate C #defines with at least a 2-byte hex value
	grep "define" "${INPUT}" -R | grep -E "0x[a-fA-F0-9]{4}($|[^a-fA-F0-9])" > "${ID_OUT}"
	# Locate USB Vendor ID define candidates
	grep "VID" < "${ID_OUT}" > "${VID_OUT}"
	# Locate USB Product ID define candidates
	grep "PID" < "${ID_OUT}" > "${PID_OUT}"
	# Print statistics
	vid_cnt=$(wc -l < "${VID_OUT}")
	pid_cnt=$(wc -l < "${PID_OUT}")
	echo "Found ${vid_cnt} VIDs and ${pid_cnt} PIDs that should be evaluated."
fi

cp "${VID_OUT}" "${VID_MISSING}"
if [[ -f "${VID_VERIFIED}" ]]; then
	while read define; do
		if [[ -n "${define}" ]]; then
			sed -i "/$define/d" "${VID_MISSING}"
		fi
	done < "${VID_VERIFIED}"
fi

cp "${PID_OUT}" "${PID_MISSING}"
if [[ -f "${PID_VERIFIED}" ]]; then
	while read define; do
		if [[ -n "${define}" ]]; then
			sed -i "/$define/d" "${PID_MISSING}"
		fi
	done < "${PID_VERIFIED}"
fi

echo "Vendor ID status:"
vid_missing_cnt=$(wc -l < "${VID_MISSING}")
vid_missing_pct=$(echo "scale=2; $vid_missing_cnt * 100 / $vid_cnt" | bc)
echo -e "\tMissing: ${vid_missing_pct}% (${vid_missing_cnt}/${vid_cnt})"
if [[ -f "${VID_VERIFIED}" ]]; then
	vid_verified_cnt=$(cat "${VID_VERIFIED}" | grep -v "^$" | wc -l)
	vid_verified_pct=$(echo "scale=2; $vid_verified_cnt * 100 / $vid_cnt" | bc)
	echo -e "\tVerified: ${vid_verified_pct}% (${vid_verified_cnt}/${vid_cnt})"
fi

echo "Product ID status:"
pid_missing_cnt=$(wc -l < "${PID_MISSING}")
pid_missing_pct=$(echo "scale=2; $pid_missing_cnt * 100 / $pid_cnt" | bc)
echo -e "\tMissing: ${pid_missing_pct}% (${pid_missing_cnt}/${pid_cnt})"
if [[ -f "${PID_VERIFIED}" ]]; then
	pid_verified_cnt=$(cat "${PID_VERIFIED}" | grep -v "^$" | wc -l)
	pid_verified_pct=$(echo "scale=2; $pid_verified_cnt * 100 / $pid_cnt" | bc)
	echo -e "\tVerified: ${pid_verified_pct}% (${pid_verified_cnt}/${pid_cnt})"
fi


