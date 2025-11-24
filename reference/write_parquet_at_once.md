# write parquet file or dataset based on partition argument 

Low level function that implements the logic to write a parquet file or
a dataset from data

## Usage

``` r
write_parquet_at_once(
  data,
  path_to_parquet,
  partition = "no",
  compression = "snappy",
  compression_level = NULL,
  ...
)
```

## Arguments

- data:

  the data.frame/tibble to write

- path_to_parquet:

  String that indicates the path to the directory where the output
  parquet file or dataset will be stored.

- partition:

  string ("yes" or "no" - by default) that indicates whether you want to
  create a partitioned parquet file. If "yes", `"partitioning"` argument
  must be filled in. In this case, a folder will be created for each
  modality of the variable filled in `"partitioning"`.

- compression:

  compression algorithm. Default "snappy".

- compression_level:

  compression level. Meaning depends on compression algorithm.

- ...:

  Additional format-specific arguments, see
  [arrow::write_parquet()](https://arrow.apache.org/docs/r/reference/write_parquet.html)

## Value

a dataset as return by arrow::open_dataset

## Examples

``` r
write_parquet_at_once(iris, tempfile())
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a760ec3bf
#> Writing data...

write_parquet_at_once(iris, tempfile(), partition = "yes", partitioning = c("Species"))
#> Writing data...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp0XSNj6/file18a7680a32cb
#> Writing data...

if (FALSE) { # \dontrun{
write_parquet_at_once(iris, tempfile(), compression="gzip", compression_level = 5)
} # }
```
