#!/bin/bash

set -ex

echo "hi"

INPUT=$1

# Clean up and create temporary directory
TMP_DIR="tmp"
rm -rf ${TMP_DIR}
mkdir ${TMP_DIR}

safe_counter="0"

# Split by line
while IFS="" read -r LINE ; do
	PREV_NUMBER=""
	PREV_SIGN=""
	# Check each line. Assume it is good, and skip it when the first error is found.
	for NUMBER in $LINE ; do
		# First iteration we just skip. We remember the number we saw
		if [[ $PREV_NUMBER == "" ]]; then PREV_NUMBER=$NUMBER; continue; fi

		# Calculate the difference and record the sign
		DIFF=$(($PREV_NUMBER - $NUMBER))
		if [[ "$DIFF" =~ "-" ]]; then SIGN="-"; else SIGN="+"; fi

		# If this is the first difference we do, remember the sign
		if [[ $PREV_SIGN == "" ]]; then PREV_SIGN=$SIGN; fi

		# A difference in the sign, or a difference other than ±1, ±2 or ±3 immediatly breaks the loop.
		# The "continue 2" here breaks the for loop _and_ sends us to the next iteration of the while loop.
		# This way we skip  the increment of safe_counter variable
		if [[ ! $PREV_SIGN == $SIGN ]]; then continue 2; fi
		if [[ ! "$DIFF" =~ ^-?[123]$ ]]; then continue 2; fi
		PREV_NUMBER=$NUMBER
		PREV_SIGN=$SIGN
	done
	# If we reach this bit of code, the sequence is safe!
	safe_counter=$(($safe_counter + 1))
done < $INPUT

echo $safe_counter
