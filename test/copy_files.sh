#!/bin/bash

# Default values
OUTPUT_DIR="/tmp/testing/input"
SOURCE_FILE=""
COUNT_FILE=""
COUNT_NUM=0
SUMMARY=true

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --output-dir=*)
      OUTPUT_DIR="${1#*=}"
      shift
      ;;
    --source-file=*)
      SOURCE_FILE="${1#*=}"
      shift
      ;;
    --name=*)
      FILE_NAME="${1#*=}"
      shift
      ;;
    --count-file=*)
      COUNT_FILE="${1#*=}"
      shift
      ;;
    --count=*)
      COUNT_NUM="${1#*=}"
      shift
      ;;
    --no-summary)
      SUMMARY=false
      shift
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --output-dir=DIR    Output directory for generated files (default: /tmp/input_csv)"
      echo "  --source-file=FILE  Source file to use as template"
      echo "  --name=FILE         Set output file name"
      echo "  --count-file=FILE   File containing counts for multiple output files"
      echo "  --count=NUMBER      Generate a single file with NUMBER copies of source"
      echo "  --no-summary        Don't display summary at the end"
      echo "  -h, --help          Display this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for available options"
      exit 1
      ;;
  esac
done

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check for required parameters
if [ -z "$SOURCE_FILE" ]; then
  echo "Error: Source file not specified. Use --source-file=FILE"
  exit 1
fi

if [ ! -f "$SOURCE_FILE" ]; then
  echo "Error: Source file '$SOURCE_FILE' does not exist"
  exit 1
fi

# Initialize array to store file information for summary
declare -a created_files

# Process count file if provided
if [ -n "$COUNT_FILE" ]; then
  if [ ! -f "$COUNT_FILE" ]; then
    echo "Error: Count file '$COUNT_FILE' does not exist"
    exit 1
  fi
  
  # Read each line from the count file
  while read -r line; do
    # Skip empty lines or comments
    [[ -z "$line" || "$line" =~ ^#.* ]] && continue
    
    # Extract count and filename
    count=$(echo "$line" | awk '{print $1}')
    filename=$(echo "$line" | awk '{print $2}')
    
    echo $count $filename
    if [[ ! "$count" =~ ^[0-9]+$ ]]; then
      echo "Warning: Invalid count '$count' in count file, skipping"
      continue
    fi
    
    # Create output file path
    if [ -n "$FILE_NAME" ]; then
      output_file="$OUTPUT_DIR/$FILE_NAME"
    else
      output_file="$OUTPUT_DIR/$filename"
    fi
    
    # Generate file content
    > "$output_file"  # Create/truncate file
    for ((i=1; i<=count; i++)); do
      cat "$SOURCE_FILE" >> "$output_file"
    done
    
    # Save file info for summary
    line_count=$(wc -l < "$output_file")
    created_files+=("$output_file:$line_count")
    
    echo "Created $output_file with $count copies (total $line_count lines)"
  done < "$COUNT_FILE"

# Process single count if provided
elif [ "$COUNT_NUM" -gt 0 ]; then
  # Generate filename based on source file or use provided name
  if [ -n "$FILE_NAME" ]; then
    output_file="$OUTPUT_DIR/$FILE_NAME"
  else
    source_basename=$(basename "$SOURCE_FILE")
    output_file="$OUTPUT_DIR/${source_basename%.*}_${COUNT_NUM}.csv"
  fi
  
  # Generate file content
  > "$output_file"  # Create/truncate file
  for ((i=1; i<=COUNT_NUM; i++)); do
    cat "$SOURCE_FILE" >> "$output_file"
  done
  
  # Save file info for summary
  line_count=$(wc -l < "$output_file")
  created_files+=("$output_file:$line_count")
  
  echo "Created $output_file with $COUNT_NUM copies (total $line_count lines)"
else
  echo "Error: Either --count-file or --count must be specified"
  exit 1
fi

# Display summary if enabled
if [ "$SUMMARY" = true ]; then
  echo ""
  echo "=== SUMMARY ==="
  echo "Total files created: ${#created_files[@]}"
  for file_info in "${created_files[@]}"; do
    file_path="${file_info%%:*}"
    line_count="${file_info#*:}"
    file_name=$(basename "$file_path")
    echo "- $file_name: $line_count lines"
  done
fi
