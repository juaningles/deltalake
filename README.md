# deltalake
deltalake, pandas, polars, fsspec


Some test results:
model name      : 12th Gen Intel(R) Core(TM) i7-12700KF
{ "method": "polars-lazy","records": "2,920,128","readtime": "0.00","readput": "2,920,128,000","writetime": "13.01","writeput": "224,383","totaltime": "13.02" }
{ "method": "polars","records": "2,920,128","readtime": "2.42","readput": "1,209,162","writetime": "3.67","writeput": "796,109","totaltime": "6.08" }
{ "method": "pandas","records": "2,920,128","readtime": "105.00","readput": "27,809","writetime": "16.99","writeput": "171,832","totaltime": "122.00" }

