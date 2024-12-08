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
	for NUMBER in $LINE ; do
		if [[ $PREV_NUMBER == "" ]]; then PREV_NUMBER=$NUMBER; continue; fi
		DIFF=$(($PREV_NUMBER - $NUMBER))
		if [[ "$DIFF" =~ "-" ]]; then SIGN="-"; else SIGN="+"; fi
		if [[ $PREV_SIGN == "" ]]; then PREV_SIGN=$SIGN; fi
		if [[ ! $PREV_SIGN == $SIGN ]]; then continue 2; fi
		if [[ ! "$DIFF" =~ ^-?[123]$ ]]; then continue 2; fi
		PREV_NUMBER=$NUMBER
		PREV_SIGN=$SIGN
	done
	safe_counter=$(($safe_counter + 1))
done < $INPUT

echo $safe_counter
