# parquetize 0.5.6

This release includes :

#### Check_parquet function

- a new [check_parquet](../reference/check_parquet.html) function that check if a dataset/file is valid and return columns and arrow type

#### Deprecations

Two arguments are deprecated to avoid confusion with arrow concept and keep consistency

* `chunk_size` is replaced by `max_rows` (chunk size is an arrow concept).
* `chunk_memory_size` is replaced by `max_memory` for consistency

#### Other

- a big test's refactoring : all _to_parquet output files are formally validate (readable as parquet, number of lines, partitions).
- use cli_abort instead of cli_alert_danger with stop("") everywhere
- some minors changes
- bugfix: table_to_parquet did not select columns as expected

# parquetize 0.5.5

This release includes :  

#### A very important new contributor to `parquetize` !

Due to these numerous contributions, @nbc is now officially part of the project authors !

#### Three arguments deprecation

After a big refactoring, three arguments are deprecated :

* `by_chunk` : `table_to_parquet` will automatically chunked if you use one of `chunk_memory_size` or `chunk_size`.
* `csv_as_a_zip`: `csv_to_table` will detect if file is a zip by the extension.
* `url_to_csv` : use `path_to_csv` instead, `csv_to_table` will detect if the file is remote with the file path.

They will raise a deprecation warning for the moment.

#### Chunking by memory size

The possibility to chunk parquet by memory size with `table_to_parquet()`:
`table_to_parquet()` takes a `chunk_memory_size` argument to convert an input
file into parquet file of roughly `chunk_memory_size` Mb size when data are
loaded in memory.

Argument `by_chunk` is deprecated (see above).

Example of use of the argument `chunk_memory_size`:  

```{r}
table_to_parquet(
  path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
  path_to_parquet = tempdir(),
  chunk_memory_size = 5000, # this will create files of around 5Gb when loaded in memory
)
```

#### Passing argument like compression to `write_parquet` when chunking

The functionality for users to pass argument to `write_parquet()` when
chunking argument (in the ellipsis). Can be used for example to pass
`compression` and `compression_level`.

Example:  

```{r}
table_to_parquet(
  path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
  path_to_parquet = tempdir(),
  compression = "zstd",
  compression_level = 10,
  chunk_memory_size = 5000
)
```

#### A new function `download_extract` 

This function is added to ... download and unzip file if needed.

```{r}
file_path <- download_extract(
  "https://www.nomisweb.co.uk/output/census/2021/census2021-ts007.zip",
  filename_in_zip = "census2021-ts007-ctry.csv"
)
csv_to_parquet(
  file_path,
  path_to_parquet = tempdir()
)
```

#### Other

Under the cover, this release has hardened tests

# parquetize 0.5.4

This release fix an error when converting a sas file by chunk.

# parquetize 0.5.3

This release includes :  

- Added columns selection to `table_to_parquet()` and `csv_to_parquet()` functions #20
- The example files in parquet format of the iris table have been migrated to the `inst/extdata` directory.

# parquetize 0.5.2

This release includes :  

- The behaviour of `table_to_parquet()` function has been fixed when the argument `by_chunk` is TRUE.  

# parquetize 0.5.1

This release removes `duckdb_to_parquet()` function on the advice of Brian Ripley from CRAN.  
Indeed, the storage of DuckDB is not yet stable. The storage will be stabilized when version 1.0 releases.

# parquetize 0.5.0

This release includes corrections for CRAN submission.

# parquetize 0.4.0

**This release includes an important feature :**

The  `table_to_parquet()` function can now convert tables to parquet format with less memory consumption.
Useful for huge tables and for computers with little RAM. (#15)
A vignette has been written about it. See [here](https://ddotta.github.io/parquetize/articles/aa-conversions.html).  

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
