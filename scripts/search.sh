#!/bin/bash

set -e # Exit script if any statement returns a non-true value.
set -u # Exit script if using an uninitialized variable.
#set -x # Script debug

################################################################################
# DEFINES
################################################################################

INPUT=""

OUT_DIR="./out"
ID_OUT="${OUT_DIR}/ids.txt"
VID_OUT="${OUT_DIR}/vids.txt"
PID_OUT="${OUT_DIR}/pids.txt"
VPID_OUT="${OUT_DIR}/vpids.txt"
VID_MISSING="${OUT_DIR}/vids_missing.txt"
PID_MISSING="${OUT_DIR}/pids_missing.txt"
VPID_MISSING="${OUT_DIR}/vpids_missing.txt"

VERIFIED_DIR="./verified"
VID_VERIFIED="${VERIFIED_DIR}/vid_defines.txt"
PID_VERIFIED="${VERIFIED_DIR}/pid_defines.txt"
PID_HIDDEN="${VERIFIED_DIR}/pid_hidden.txt"
VPID_VERIFIED="${VERIFIED_DIR}/vpid_macros.txt"

HEX_FILTER="0x[a-fA-F0-9]{4}($|[^a-fA-F0-9])"

VID_FILTER="VID\|VENDER_ID\|VENDOR_ID"
PID_FILTER="PID\|PRODUCT_ID\|USB_DEVICE_ID"
VPID_FILTER="USB_DEVICE("

VID_BLACKLIST="define VIDEO\|VIDEOPLL\|CLKSEL_VIDEO\|CMD_VIDEO\|PCI_VENDOR_ID\|PCI_DEVICE_ID\|_PID"
PID_BLACKLIST="PCI_DEVICE_ID\|SPIDER_PCI"
VPID_BLACKLIST="IS_USB_DEVICE\|USB_DEVICE()"


################################################################################
# FUNCTIONS
################################################################################

locate_ids()
{
	if [[ -d "$INPUT" ]]; then
		mkdir -p "${OUT_DIR}"
		mkdir -p "${VERIFIED_DIR}"

		set +e
		# Locate C #defines with at least a 2-byte hex value
		grep 'define' "${INPUT}" --exclude-dir=".git" -R | grep -E "${HEX_FILTER}" > "${ID_OUT}"
		# Locate USB Vendor ID define candidates
		grep "${VID_FILTER}" < "${ID_OUT}" | grep -v "${VID_BLACKLIST}" > "${VID_OUT}"
		# Locate USB Product ID define candidates
		grep "${PID_FILTER}" < "${ID_OUT}" | grep -v "${PID_BLACKLIST}" > "${PID_OUT}"
		# Locate C macro
		grep -a "${VPID_FILTER}" "${INPUT}" --exclude-dir=".git" -R | grep -v "${VPID_BLACKLIST}" > "${VPID_OUT}"
		set -e

		# Append hidden and unsearchable PIDs
		cat "${PID_HIDDEN}" >> "${PID_OUT}"

		# Print statistics
		vid_cnt=$(wc -l < "${VID_OUT}")
		pid_cnt=$(wc -l < "${PID_OUT}")
		vpid_cnt=$(wc -l < "${VPID_OUT}")
		echo "Found ${vid_cnt} VIDs, ${pid_cnt} PIDs and ${vpid_cnt} VID/PIDs that should be evaluated."
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
			else
				# Only count things that makes sense.
				sed -i "/$define/d" "${missing}"
			fi
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
	touch "${missing}"
	missing_cnt=$(wc -l < "${missing}")
	if [[ "${missing_cnt}" -gt 0 ]]; then
		progress_cnt=$((total_cnt - missing_cnt))
		missing_pct=$(echo "scale=2; $progress_cnt * 100 / $total_cnt" | bc)
		echo -e "\tProgress: ${missing_pct}% (${progress_cnt}/${total_cnt})"
	else
		echo -e "\tProgress: 100.00% (0/0)"
	fi
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
	echo "Searching for possible USB IDs..."
	INPUT=$1
fi

locate_ids

parse_verified_ids "${VID_OUT}" "${VID_MISSING}" "${VID_VERIFIED}"
parse_verified_ids "${PID_OUT}" "${PID_MISSING}" "${PID_VERIFIED}"
parse_verified_ids "${VPID_OUT}" "${VPID_MISSING}" "${VPID_VERIFIED}"

echo; echo "Vendor ID status:"
print_id_status "${vid_cnt}" "${VID_MISSING}"

echo; echo "Product ID status:"
print_id_status "${pid_cnt}" "${PID_MISSING}"

echo; echo "Vendor and/or Product ID status:"
print_id_status "${vpid_cnt}" "${VPID_MISSING}"

echo; echo "Complete..."; echo


