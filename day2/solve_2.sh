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
	# Get the length of the line. We will be checking the line itself and all the sequences that are obtained
	# by removing a single number from it.
	LEN=$(echo $LINE | wc -w)
	# This is crucial, we'll be abusing the fact that "cut" allows you to specify a field that does not exist. We count in a decreasing fashion
	# so that the very first thing we do is to check the entire line. So, if the line has 5 numbers, well do 6 5 4 3 2 1...
	for i in $(seq $(($LEN + 1)) -1 1) ; do
		# The number i is the "field to skip". If it is greater than the number of fields in the line, nothing will be skipped.
		# Normally "cut -fn" will only show field number n, but by using --complement we get _all fields but n_.
		TEST_LINE=$(echo $LINE | cut --complement -f$i -d" ")

		# Now it's the same logic to check the line.
		PREV_NUMBER=""
		PREV_SIGN=""
		for NUMBER in $TEST_LINE ; do
			if [[ $PREV_NUMBER == "" ]]; then PREV_NUMBER=$NUMBER; continue; fi
			DIFF=$(($PREV_NUMBER - $NUMBER))
			if [[ "$DIFF" =~ "-" ]]; then SIGN="-"; else SIGN="+"; fi
			if [[ $PREV_SIGN == "" ]]; then PREV_SIGN=$SIGN; fi

			# This "continue 2" will skip two for loops before, that is, we'll generate a new TEST_LINE.
			if [[ ! $PREV_SIGN == $SIGN ]]; then continue 2; fi
			if [[ ! "$DIFF" =~ ^-?[123]$ ]]; then continue 2; fi
			PREV_NUMBER=$NUMBER
			PREV_SIGN=$SIGN
		done
		# The first time we see _any_ sequence succeed for a LINE, we mark it as safe and skip to the main while
		safe_counter=$(($safe_counter + 1))
		continue 2
	done
done < $INPUT

echo $safe_counter
