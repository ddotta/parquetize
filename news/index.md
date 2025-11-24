# Changelog

## parquetize 0.5.7

CRAN release: 2024-03-04

This release includes :

- bugfix by [@leungi](https://github.com/leungi): remove single quotes
  in SQL statement thatgenerates incorrect SQL syntax for connection of
  type Microsoft SQL Server
  [\#45](https://github.com/ddotta/parquetize/issues/45)
- [parquetize](https://ddotta.github.io/parquetize/) now has a minimal
  version (2.4.0) for [haven](https://haven.tidyverse.org) dependency
  package to ensure that conversions are performed correctly from SAS
  files compressed in BINARY mode
  [\#46](https://github.com/ddotta/parquetize/issues/46)
- `csv_to_parquet` now has a `read_delim_args` argument, allowing
  passing of arguments to `read_delim` (added by
  [@nikostr](https://github.com/nikostr)).
- `table_to_parquet` can now convert files with uppercase extensions
  (.SAS7BDAT, .SAV, .DTA)

## parquetize 0.5.6.1

CRAN release: 2023-05-10

This release includes :

##### fst_to_parquet function

- a new
  [fst_to_parquet](https://ddotta.github.io/parquetize/reference/fst_to_parquet.html)
  function that converts a fst file to parquet format.

##### Other

- Rely more on `@inheritParams` to simply documentation of functions
  arguments [\#38](https://github.com/ddotta/parquetize/issues/38). This
  leads to some renaming of arguments (e.g `path_to_csv` -\>
  `path_to_file`…)
- Arguments `compression` and `compression_level` are now passed to
  write_parquet_at_once and write_parquet_by_chunk functions and now
  available in main conversion functions of `parquetize`
  [\#36](https://github.com/ddotta/parquetize/issues/36)
- Group `@importFrom` in a file to facilitate their maintenance
  [\#37](https://github.com/ddotta/parquetize/issues/37)
- work on download_extract tests
  [\#43](https://github.com/ddotta/parquetize/issues/43)

## parquetize 0.5.6

This release includes :

##### Possibility to use a RDBMS as source

You can convert to parquet any query you want on any DBI compatible
RDBMS :

\`\`\`{r} dbi_connection \<- DBI::dbConnect(RSQLite::SQLite(),
system.file(“extdata”,“iris.sqlite”,package = “parquetize”))

## parquetize 0.5.4

CRAN release: 2023-03-13

This release fix an error when converting a sas file by chunk.

## parquetize 0.5.3

CRAN release: 2023-02-20

This release includes :

- Added columns selection to
  [`table_to_parquet()`](../reference/table_to_parquet.md) and
  [`csv_to_parquet()`](../reference/csv_to_parquet.md) functions
  [\#20](https://github.com/ddotta/parquetize/issues/20)
- The example files in parquet format of the iris table have been
  migrated to the `inst/extdata` directory.

## parquetize 0.5.2

This release includes :

- The behaviour of
  [`table_to_parquet()`](../reference/table_to_parquet.md) function has
  been fixed when the argument `by_chunk` is TRUE.

## parquetize 0.5.1

CRAN release: 2023-01-30

This release removes `duckdb_to_parquet()` function on the advice of
Brian Ripley from CRAN.  
Indeed, the storage of DuckDB is not yet stable. The storage will be
stabilized when version 1.0 releases.

## parquetize 0.5.0

CRAN release: 2023-01-13

This release includes corrections for CRAN submission.

## parquetize 0.4.0

**This release includes an important feature :**

The [`table_to_parquet()`](../reference/table_to_parquet.md) function
can now convert tables to parquet format with less memory consumption.
Useful for huge tables and for computers with little RAM.
([\#15](https://github.com/ddotta/parquetize/issues/15)) A vignette has
been written about it. See
[here](https://ddotta.github.io/parquetize/articles/aa-conversions.html).

- Removal of the `nb_rows` argument in the
  [`table_to_parquet()`](../reference/table_to_parquet.md) function
- Replaced by new arguments `by_chunk`, `chunk_size` and `skip` (see
  documentation)
- Progress bars are now managed with [{cli}
  package](https://github.com/r-lib/cli)

## parquetize 0.3.0

- Added `duckdb_to_parquet()` function to convert duckdb files to
  parquet format.
- Added [`sqlite_to_parquet()`](../reference/sqlite_to_parquet.md)
  function to convert sqlite files to parquet format.

## parquetize 0.2.0

- Added [`rds_to_parquet()`](../reference/rds_to_parquet.md) function to
  convert rds files to parquet format.
- Added [`json_to_parquet()`](../reference/json_to_parquet.md) function
  to convert json and ndjson files to parquet format.
- Added the possibility to convert a csv file to a partitioned parquet
  file.
- Improving code coverage
  ([\#9](https://github.com/ddotta/parquetize/issues/9))
- Check if `path_to_parquet` exists in functions
  [`csv_to_parquet()`](../reference/csv_to_parquet.md) or
  [`table_to_parquet()`](../reference/table_to_parquet.md)
  ([@py-b](https://github.com/py-b))

## parquetize 0.1.0

- Added [`table_to_parquet()`](../reference/table_to_parquet.md)
  function to convert SAS, SPSS and Stata files to parquet format.
- Added [`csv_to_parquet()`](../reference/csv_to_parquet.md) function to
  convert csv files to parquet format.
- Added [`parquetize_example()`](../reference/parquetize_example.md)
  function to get path to package data examples.
- Added a `NEWS.md` file to track changes to the package.
