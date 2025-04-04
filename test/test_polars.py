import polars as pl
import os, sys, json
from deltalake.writer import write_deltalake
import time

def current_milli_time():
    return round(time.time() * 1000)

script_path = os.path.dirname(os.path.abspath(__file__))
output_path = os.environ['OUTPUT_DIR'] if os.environ.get('OUTPUT_DIR') else '/output'

input_files = os.environ['INPUT_FILES'] if os.environ.get('INPUT_FILES') else f'{script_path}/json/incidents.json'
entity_name = os.environ['ENTITY_NAME'] if os.environ.get('ENTITY_NAME') else 'sample_incidents'
delta_mode = os.environ['DELTA_MODE'] if os.environ.get('DELTA_MODE') else "append"
delta_demo = os.environ['DELTA_DEMO'] if os.environ.get('DELTA_DEMO') else None

storage_options = {}
try:
    storage_options_json = os.environ['DELTA_STORAGE_OPTIONS'] if os.environ.get('DELTA_STORAGE_OPTIONS') else '{"allow_unsafe_rename": "true"}'
    storage_options_dict = json.loads(storage_options_json)
    storage_options = storage_options_dict
except Exception as e:
    print("Error reading DELTA_STORAGE_OPTIONS", file=sys.stderr)
    print(e, file=sys.stderr)
    print("Using default storage options", file=sys.stderr)

if delta_demo:
    df_1 = pl.DataFrame({"data": range(6, 11)})
    print(f"Generating DeltaTable Demo: {output_path}/demo")
    if storage_options:
        print("Storage Options: ")
        print(storage_options)
    #print(df_1)
    df_1.write_delta(f"{output_path}/demo", mode="append")
    # Read the Delta Lake table
    dt = pl.read_delta(f"{output_path}/demo")
    print("results:")
    print(dt)

# Create a polars DataFrame
print(f"Reading file(s): {input_files}")
start_time = current_milli_time()
df_2 = ( pl.read_ndjson(f'{input_files}'))

write_start_time = current_milli_time()

print(f"DeltaTable Mode: {delta_mode}")
print(f"Generating DeltaTable: {output_path}/{entity_name}")
if storage_options:
    print("Storage Options: ")
    print(storage_options)
df_2.write_delta(f"{output_path}/{entity_name}", mode=delta_mode, storage_options=storage_options)
write_time = current_milli_time()

write_duration = write_time - write_start_time
read_duration = write_start_time - start_time
total_duration = write_duration + read_duration
record_count = len(df_2)
records_per_second = int(record_count / (total_duration / 1000)) if total_duration > 0 else 0
read_throughput = int(record_count / (read_duration/1000)) if read_duration > 0 else 0
write_throughput = int(record_count / (write_duration/1000)) if write_duration > 0 else 0

# Performance summary
print("\n======= PERFORMANCE SUMMARY =======")
print(f"Method: polars")
print(f"Records processed: {record_count:,}")
print(f"Read time: {read_duration/1000:.2f} seconds")
print(f"Read throughput: {read_throughput:,} records/second")
print(f"Write time: {write_duration/1000:.2f} seconds")
print(f"Write throughput: {write_throughput:,} records/second")
print(f"Total processing time: {total_duration/1000:.2f} seconds")
print(f"Overall throughput: {records_per_second:,} records/second")
print("==================================\n")

print("{",
f'"method": "polars",'
f'"records": "{record_count:,}",'
f'"readtime": "{read_duration/1000:.2f}",'
f'"readput": "{read_throughput:,}",'
f'"writetime": "{write_duration/1000:.2f}",'
f'"writeput": "{write_throughput:,}",'
f'"totaltime": "{total_duration/1000:.2f}"',"}"
)

if entity_name:
    # Read the Delta Lake table
    dt = pl.read_delta(f"{output_path}/{entity_name}")
    print(f"\nReading: {output_path}/{entity_name}")
    print(dt)

