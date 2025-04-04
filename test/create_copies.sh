SOURCE_FILE=json/incidents.json 

# Get multiplier count from env var or use default value of 1
MULTIPLIER_COUNT=${1:-${MULTIPLIER_COUNT:-1}}
SEED=42

# Loop the specified number of times
for ((i=1; i<=$MULTIPLIER_COUNT; i++)); do
  echo "Running iteration $i of $MULTIPLIER_COUNT"
    cat counts.txt | xargs -IXXX bash -c "bash copy_files.sh --no-summary --source-file=json/incidents.json --name=\$(date +%s.%N)-\$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c\${1:-5}).json  --count=XXX"
done
