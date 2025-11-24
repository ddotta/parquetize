# Convert a json file to parquet format

This function allows to convert a
[json](https://www.json.org/json-en.html) or
[ndjson](https://docs.mulesoft.com/dataweave/latest/dataweave-formats-ndjson)
file to parquet format.  

Two conversions possibilities are offered :

- Convert to a single parquet file. Argument `path_to_parquet` must then
  be used;

- Convert to a partitioned parquet file. Additionnal arguments
  `partition` and `partitioning` must then be used;

## Usage

``` r
json_to_parquet(
  path_to_file,
  path_to_parquet,
  format = "json",
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

- path_to_parquet:

  String that indicates the path to the directory where the parquet
  files will be stored.

- format:

  string that indicates if the format is "json" (by default) or "ndjson"

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
# Conversion from a local json file to a single parquet file ::

json_to_parquet(
  path_to_file = system.file("extdata","iris.json",package = "parquetize"),
  path_to_parquet = tempfile(fileext = ".parquet")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp6AeROy/file18ce976be2a.parquet
#> Writing data...
#> Reading data...

# Conversion from a local ndjson file to a partitioned parquet file  ::

json_to_parquet(
  path_to_file = system.file("extdata","iris.ndjson",package = "parquetize"),
  path_to_parquet = tempfile(fileext = ".parquet"),
  format = "ndjson"
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp6AeROy/file18ceb7ca7a1.parquet
#> Writing data...
#> Reading data...
```
