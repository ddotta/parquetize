# parquetize 0.4.0

**This release includes an important feature :**

The  `table_to_parquet()` function can now convert tables to parquet format with less memory consumption.
Useful for huge tables and for computers with little RAM. (#15)

* Removal of the `nb_rows` argument in the `table_to_parquet()` function
* Replaced by new arguments `by_chunk`, `chunk_size` and `skip` (see documentation)
* Progress bars are now managed with [{cli} package](https://github.com/r-lib/cli)

# parquetize 0.3.0

* Added `duckdb_to_parquet()` function to convert duckdb files to parquet format.
* Added `sqlite_to_parquet()` function to convert sqlite files to parquet format.

# parquetize 0.2.0

* Added `rds_to_parquet()` function to convert rds files to parquet format.
* Added `json_to_parquet()` function to convert json and ndjson files to parquet format.
* Added the possibility to convert a csv file to a partitioned parquet file.
* Improving code coverage (#9)
* Check if `path_to_parquet` exists in functions `csv_to_parquet()` or `table_to_parquet()` (@py-b)


# parquetize 0.1.0

* Added `table_to_parquet()` function to convert SAS, SPSS and Stata files to parquet format.
* Added `csv_to_parquet()` function to convert csv files to parquet format.
* Added `parquetize_example()` function to get path to package data examples.
* Added a `NEWS.md` file to track changes to the package.
