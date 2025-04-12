#! /bin/bash

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Export MULTIPLIER_COUNT if it's not set
save_MULTIPLIER_COUNT=$MULTIPLIER_COUNT
export MULTIPLIER_COUNT=1
cp counts.txt backup_counts.txt 
echo 10 > counts.txt
bash perf-test.sh
export MULTIPLIER_COUNT=$save_MULTIPLIER_COUNT
cat backup_counts.txt > counts.txt
rm backup_counts.txt
echo -e "\n===== Short Testing Complete ====="


