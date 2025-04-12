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

sleep_time = os.environ['SLEEP_TIME'] if os.environ.get('SLEEP_TIME') else 60

if sleep_time:
    print(f"Sleeping for {sleep_time} seconds")
    time.sleep(int(sleep_time))

print(f"Done.")
