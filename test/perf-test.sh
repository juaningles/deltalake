#! /bin/bash

# Change to the directory where the script is located
cd "$(dirname "$0")"

# Export MULTIPLIER_COUNT if it's not set
export MULTIPLIER_COUNT=${$1:-1}
echo "Using MULTIPLIER_COUNT=$MULTIPLIER_COUNT"

echo "===== Creating test data ====="
bash create_copies.sh

echo -e "\n===== Running Pandas Performance Test ====="
ENTITY_NAME=incidents_pandas INPUT_FILES=/tmp/input/*.json OUTPUT_DIR=/tmp/data  python3 test_pandas.py

echo -e "\n===== Running Polars Performance Test ====="
ENTITY_NAME=incidents_polars INPUT_FILES=/tmp/input/*.json OUTPUT_DIR=/tmp/data  python3 test_polars.py

echo -e "\n===== Running Polars-Lazy Performance Test ====="
ENTITY_NAME=incidents_polars_lazy INPUT_FILES=/tmp/input/*.json OUTPUT_DIR=/tmp/data  python3 test_polars_lazy.py

echo -e "\n===== Performance Testing Complete ====="