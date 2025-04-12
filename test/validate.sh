#!/bin/bash

# Initialize verbose flag
VERBOSE=false

# Parse command line arguments
SEARCH_PATH=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --verbose)
            VERBOSE=true
            shift
            ;;
        *)
            if [ -z "$SEARCH_PATH" ]; then
                SEARCH_PATH="$1"
            else
                echo "Usage: $0 [--verbose] <directory_path>" >&2
                exit 1
            fi
            shift
            ;;
    esac
done

# Check if a path argument was provided
if [ -z "$SEARCH_PATH" ]; then
    echo "Usage: $0 [--verbose] <directory_path>" >&2
    exit 1
fi

# Check if the path exists
if [ ! -d "$SEARCH_PATH" ]; then
    echo "Error: Directory '$SEARCH_PATH' does not exist or is not a directory" >&2
    exit 1
fi

# Check if parquet-tools is installed
if ! command -v parquet-tools &> /dev/null; then
    echo "Error: parquet-tools is not installed or not in the PATH" >&2
    echo "Please install parquet-tools to use this script" >&2
    exit 1
fi

# Initialize counters
PASS_COUNT=0
FAIL_COUNT=0
TOTAL_COUNT=0

# Find all parquet files
echo "Validating parquet files in '$SEARCH_PATH'..."
echo "---------------------------------------------"

# Create a temporary file to store the list of parquet files
TEMP_FILE=$(mktemp)

# Find all files with .parquet extension
find "$SEARCH_PATH" -type f -name "*.parquet" > "$TEMP_FILE"

# Check if any parquet files were found
if [ ! -s "$TEMP_FILE" ]; then
    echo "No parquet files found in '$SEARCH_PATH'" >&2
    rm "$TEMP_FILE"
    exit 0
fi

# Process each parquet file
while IFS= read -r file; do
    TOTAL_COUNT=$((TOTAL_COUNT + 1))
    
    # Only print "Validating" line in verbose mode
    if $VERBOSE; then
        echo "Validating: $file"
    fi
    
    # Run parquet-tools inspect command and capture the exit status
    # Redirect stdout to /dev/null to suppress normal output
    if parquet-tools inspect "$file" > /dev/null 2>"$file".errors ; then
        echo "PASS: $file"
        rm -rf "$file".errors
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "FAIL: $file" >&2
        FAIL_COUNT=$((FAIL_COUNT + 1))
        if $VERBOSE; then
            echo "Errors logged in: ${file}.errors"
        fi
    fi
    
    # Only print newline in verbose mode
    if $VERBOSE; then
        echo ""
    fi
done < "$TEMP_FILE"

# Clean up temporary file
rm "$TEMP_FILE"


if [ $FAIL_COUNT -gt 0 ]; then
    PASS_RESULT="FAIL"
else
    PASS_RESULT="PASS"
fi


# Print summary
echo "---------------------------------------------"
echo "VALIDATION SUMMARY: $PASS_RESULT"
echo "Total parquet files found: $TOTAL_COUNT"
echo "PASS: $PASS_COUNT"
echo "FAIL: $FAIL_COUNT"
echo "---------------------------------------------"
echo "{\"results\": \"$PASS_RESULT\", \"pass\": \"$PASS_COUNT\", \"fail\": \"$FAIL_COUNT\", \"total\": \"$TOTAL_COUNT\"}"
# Exit with status code 1 if there are any failures
if [ $FAIL_COUNT -gt 0 ]; then
    exit 1
else
    exit 0
fi
