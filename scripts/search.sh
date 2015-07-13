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
# FUNCTIONS
################################################################################

locate_ids()
{
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
}

parse_verified_ids()
{
	if [[ $# -eq 3 ]]; then
		out=$1
		missing=$2
		verified=$3
	else
		return
	fi
	if [[ ! -f "${verified}" ]]; then
		return
	fi
	cp "${out}" "${missing}"
	while read define; do
		if [[ -n "${define}" ]]; then
			set +e
			found=$(grep -c "${define}" "${missing}")
			set -e
			if [[ "${found}" -eq 0 ]]; then
				echo "Warning! Unable to located (verified ID: ${define})"
			elif [[ "${found}" -gt 1 ]]; then
				echo "Warning! Multiple located (verified ID: ${define})"
			fi
			sed -i "/$define/d" "${missing}"
		fi
	done < "${verified}"
}

print_id_status()
{
	if [[ $# -eq 2 ]]; then
		total_cnt=$1
		missing=$2
	else
		return
	fi
	missing_cnt=$(wc -l < "${missing}")
	progress_cnt=$(($total_cnt - $missing_cnt))
	missing_pct=$(echo "scale=2; $progress_cnt * 100 / $total_cnt" | bc)
	echo -e "\tProgress: ${missing_pct}% (${progress_cnt}/${total_cnt})"
}


################################################################################
# MAIN
################################################################################

if [[ "$#" -ne 1 ]]; then
	echo "Usage $0 SOURCE"
	echo "SOURCE is a git clone of the Linux kernel source."
	echo "Output will be stored in working directory."
	exit 1
else
	echo "Searching for possible IDs..."
	INPUT=$1
fi

locate_ids

parse_verified_ids "${VID_OUT}" "${VID_MISSING}" "${VID_VERIFIED}"
parse_verified_ids "${PID_OUT}" "${PID_MISSING}" "${PID_VERIFIED}"

echo; echo "Vendor ID status:"
print_id_status "${vid_cnt}" "${VID_MISSING}"

echo; echo "Product ID status:"
print_id_status "${pid_cnt}" "${PID_MISSING}"

echo; echo "Complete..."; echo


