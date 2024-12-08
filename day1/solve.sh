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

sort ${TMP_DIR}/first_col > ${TMP_DIR}/first_sorted
sort ${TMP_DIR}/second_col > ${TMP_DIR}/second_sorted

paste -d- ${TMP_DIR}/first_sorted ${TMP_DIR}/second_sorted > ${TMP_DIR}/combined

for LINE in $(cat ${TMP_DIR}/combined); do
	echo $(($LINE)) | sed -e 's/-//'
done > ${TMP_DIR}/diff

echo -n 0 >> ${TMP_DIR}/diff

echo $(( $(cat ${TMP_DIR}/diff | tr '\n' + ) ))
