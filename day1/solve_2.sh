#!/bin/bash

set -ex

echo "hi"

INPUT=$1

# Clean up and create temporary directory
TMP_DIR="tmp"
rm -rf ${TMP_DIR}
mkdir ${TMP_DIR}

# Split the initial list into two files
cat ${INPUT} | awk '{print $1}' > ${TMP_DIR}/first_col
cat ${INPUT} | awk '{print $2}' > ${TMP_DIR}/second_col

# For each number on our left list...
for LINE in $(cat ${TMP_DIR}/first_col); do
	# Run a beautiful regex matching exact lines (^...$) on the right list
	# This is to prevent "342" from matching with "143425"
	COUNT=$(grep -E -c "^$LINE\$" ${TMP_DIR}/second_col || true)
	
	# Bash arithmetic expression multiplying the two
	echo $(($LINE * $COUNT))
done > ${TMP_DIR}/diff

# We do this to get rid of the last \n
echo -n 0 >> ${TMP_DIR}/diff

# Replace all the \n with + signs and parse it all in a big arithmetic expression, et voilà
echo $(( $(cat ${TMP_DIR}/diff | tr '\n' + ) ))
