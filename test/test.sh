#! /bin/bash

ENTITY_NAME=incidents_pandas OUTPUT_DIR=/tmp/data python3 test/test_pandas.py
ENTITY_NAME=incidents_polars OUTPUT_DIR=/tmp/data python3 test/test_polars.py
ENTITY_NAME=incidents_polars_lazy.parquet OUTPUT_DIR=/tmp/data python3 test/test_polars_lazy.py
