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

# Sort each list separately
sort ${TMP_DIR}/first_col > ${TMP_DIR}/first_sorted
sort ${TMP_DIR}/second_col > ${TMP_DIR}/second_sorted

# Combine the two sorted lists back into a single list, adding a `-` as a delimiter.
# This will essentially result in a file that has a bunc of substractions (assuming no neg numbers on the original input)
paste -d- ${TMP_DIR}/first_sorted ${TMP_DIR}/second_sorted > ${TMP_DIR}/combined

# This is when we do the math, for each line of our substratcion list...
for LINE in $(cat ${TMP_DIR}/combined); do
	# Do a bash arithmetic evaluation $(( ... )) of the line
	# The result could be negative still, since we don't know which list has the higher number,
	# so take the absolute value by "dropping" the - sign with sed
	echo $(($LINE)) | sed -e 's/-//'
done > ${TMP_DIR}/diff

# We do this to get rid of the last \n
echo -n 0 >> ${TMP_DIR}/diff

# We are here with the list of differences between each line
# Replace all the \n with + signs and parse it all in a big arithmetic expression, et voilà
echo $(( $(cat ${TMP_DIR}/diff | tr '\n' + ) ))
