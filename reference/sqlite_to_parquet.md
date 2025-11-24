# Convert a sqlite file to parquet format

This function allows to convert a table from a sqlite file to parquet
format.  
The following extensions are supported :
"db","sdb","sqlite","db3","s3db","sqlite3","sl3","db2","s2db","sqlite2","sl2".  

Two conversions possibilities are offered :

- Convert to a single parquet file. Argument `path_to_parquet` must then
  be used;

- Convert to a partitioned parquet file. Additionnal arguments
  `partition` and `partitioning` must then be used;

## Usage

``` r
sqlite_to_parquet(
  path_to_file,
  table_in_sqlite,
  path_to_parquet,
  partition = "no",
  compression = "snappy",
  compression_level = NULL,
  ...
)
```

## Arguments

- path_to_file:

  String that indicates the path to the input file (don't forget the
  extension).

- table_in_sqlite:

  string that indicates the name of the table to convert in the sqlite
  file

- path_to_parquet:

  String that indicates the path to the directory where the parquet
  files will be stored.

- partition:

  String ("yes" or "no" - by default) that indicates whether you want to
  create a partitioned parquet file. If "yes", `"partitioning"` argument
  must be filled in. In this case, a folder will be created for each
  modality of the variable filled in `"partitioning"`. Be careful, this
  argument can not be "yes" if `max_memory` or `max_rows` argument are
  not NULL.

- compression:

  compression algorithm. Default "snappy".

- compression_level:

  compression level. Meaning depends on compression algorithm.

- ...:

  additional format-specific arguments, see
  [arrow::write_parquet()](https://arrow.apache.org/docs/r/reference/write_parquet.html)
  and
  [arrow::write_dataset()](https://arrow.apache.org/docs/r/reference/write_dataset.html)
  for more informations.

## Value

A parquet file, invisibly

## Examples

``` r
# Conversion from a local sqlite file to a single parquet file :

sqlite_to_parquet(
  path_to_file = system.file("extdata","iris.sqlite",package = "parquetize"),
  table_in_sqlite = "iris",
  path_to_parquet = tempfile(fileext = ".parquet")
)
#> Reading data...
#> Writing data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp5JozyA/file19515183a6b.parquet
#> Writing data...
#> Writing data...

# Conversion from a local sqlite file to a partitioned parquet file  :

sqlite_to_parquet(
  path_to_file = system.file("extdata","iris.sqlite",package = "parquetize"),
  table_in_sqlite = "iris",
  path_to_parquet = tempfile(),
  partition = "yes",
  partitioning =  c("Species")
)
#> Reading data...
#> Writing data...
#> Writing data...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp5JozyA/file1951613a234b
#> Writing data...
#> Writing data...
```
