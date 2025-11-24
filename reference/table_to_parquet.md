# Convert an input file to parquet format

This function allows to convert an input file to parquet format.  

It handles SAS, SPSS and Stata files in a same function. There is only
one function to use for these 3 cases. For these 3 cases, the function
guesses the data format using the extension of the input file (in the
`path_to_file` argument).  

Two conversions possibilities are offered :

- Convert to a single parquet file. Argument `path_to_parquet` must then
  be used;

- Convert to a partitioned parquet file. Additionnal arguments
  `partition` and `partitioning` must then be used;

To avoid overcharging R's RAM, the conversion can be done by chunk. One
of arguments `max_memory` or `max_rows` must then be used. This is very
useful for huge tables and for computers with little RAM because the
conversion is then done with less memory consumption. For more
information, see
[here](https://ddotta.github.io/parquetize/articles/aa-conversions.html).

## Usage

``` r
table_to_parquet(
  path_to_file,
  path_to_parquet,
  max_memory = NULL,
  max_rows = NULL,
  chunk_size = lifecycle::deprecated(),
  chunk_memory_size = lifecycle::deprecated(),
  columns = "all",
  by_chunk = lifecycle::deprecated(),
  skip = 0,
  partition = "no",
  encoding = NULL,
  chunk_memory_sample_lines = 10000,
  compression = "snappy",
  compression_level = NULL,
  user_na = FALSE,
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

- max_memory:

  Memory size (in Mb) in which data of one parquet file should roughly
  fit.

- max_rows:

  Number of lines that defines the size of the chunk. This argument can
  not be filled in if max_memory is used.

- chunk_size:

  DEPRECATED use max_rows

- chunk_memory_size:

  DEPRECATED use max_memory

- columns:

  Character vector of columns to select from the input file (by default,
  all columns are selected).

- by_chunk:

  DEPRECATED use max_memory or max_rows instead

- skip:

  By default 0. This argument must be filled in if `by_chunk` is TRUE.
  Number of lines to ignore when converting.

- partition:

  String ("yes" or "no" - by default) that indicates whether you want to
  create a partitioned parquet file. If "yes", `"partitioning"` argument
  must be filled in. In this case, a folder will be created for each
  modality of the variable filled in `"partitioning"`. Be careful, this
  argument can not be "yes" if `max_memory` or `max_rows` argument are
  not NULL.

- encoding:

  String that indicates the character encoding for the input file.

- chunk_memory_sample_lines:

  Number of lines to read to evaluate max_memory. Default to 10 000.

- compression:

  compression algorithm. Default "snappy".

- compression_level:

  compression level. Meaning depends on compression algorithm.

- user_na:

  If `TRUE` variables with user defined missing will be read into
  [`haven::labelled_spss()`](https://haven.tidyverse.org/reference/labelled_spss.html)
  objects. If `FALSE`, the default, user-defined missings will be
  converted to `NA`.

- ...:

  Additional format-specific arguments, see
  [arrow::write_parquet()](https://arrow.apache.org/docs/r/reference/write_parquet.html)
  and
  [arrow::write_dataset()](https://arrow.apache.org/docs/r/reference/write_dataset.html)
  for more informations.

## Value

Parquet files, invisibly

## Examples

``` r
# Conversion from a SAS file to a single parquet file :

table_to_parquet(
  path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
  path_to_parquet = tempfile(fileext = ".parquet")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a76c8be6ba.parquet
#> Writing data...
#> Reading data...
#> ✔ The /home/runner/work/_temp/Library/haven/examples/iris.sas7bdat file is available in parquet format under /tmp/Rtmp0XSNj6/file18a76c8be6ba.parquet
#> Reading data...

# Conversion from a SPSS file to a single parquet file :

table_to_parquet(
  path_to_file = system.file("examples","iris.sav", package = "haven"),
  path_to_parquet = tempfile(fileext = ".parquet"),
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a73f247593.parquet
#> Writing data...
#> Reading data...
#> ✔ The /home/runner/work/_temp/Library/haven/examples/iris.sav file is available in parquet format under /tmp/Rtmp0XSNj6/file18a73f247593.parquet
#> Reading data...
# Conversion from a Stata file to a single parquet file without progress bar :

table_to_parquet(
  path_to_file = system.file("examples","iris.dta", package = "haven"),
  path_to_parquet = tempfile(fileext = ".parquet")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a72e74562d.parquet
#> Writing data...
#> Reading data...
#> ✔ The /home/runner/work/_temp/Library/haven/examples/iris.dta file is available in parquet format under /tmp/Rtmp0XSNj6/file18a72e74562d.parquet
#> Reading data...

# Reading SPSS file by chunk (using `max_rows` argument)
# and conversion to multiple parquet files :

table_to_parquet(
  path_to_file = system.file("examples","iris.sav", package = "haven"),
  path_to_parquet = tempfile(),
  max_rows = 50,
)
#> Reading data...
#> Writing file18a7416e3ca7-1-50.parquet...
#> Reading data...
#> Writing file18a7416e3ca7-51-100.parquet...
#> Reading data...
#> Writing file18a7416e3ca7-101-150.parquet...
#> Reading data...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp0XSNj6/file18a7416e3ca7/
#> Reading data...

# Reading SPSS file by chunk (using `max_memory` argument)
# and conversion to multiple parquet files of 5 Kb when loaded (5 Mb / 1024)
# (in real files, you should use bigger value that fit in memory like 3000
# or 4000) :

table_to_parquet(
  path_to_file = system.file("examples","iris.sav", package = "haven"),
  path_to_parquet = tempfile(),
  max_memory = 5 / 1024
)
#> Reading data...
#> Writing file18a71902a962-1-82.parquet...
#> Reading data...
#> Writing file18a71902a962-83-150.parquet...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp0XSNj6/file18a71902a962/
#> Writing file18a71902a962-83-150.parquet...

# Reading SAS file by chunk of 50 lines with encoding
# and conversion to multiple files :

table_to_parquet(
  path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
  path_to_parquet = tempfile(),
  max_rows = 50,
  encoding = "utf-8"
)
#> Reading data...
#> Writing file18a75d94ec95-1-50.parquet...
#> Reading data...
#> Writing file18a75d94ec95-51-100.parquet...
#> Reading data...
#> Writing file18a75d94ec95-101-150.parquet...
#> Reading data...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp0XSNj6/file18a75d94ec95/
#> Reading data...

# Conversion from a SAS file to a single parquet file and select only
# few columns  :

table_to_parquet(
  path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
  path_to_parquet = tempfile(fileext = ".parquet"),
  columns = c("Species","Petal_Length")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a7316584bc.parquet
#> Writing data...
#> Reading data...
#> ✔ The /home/runner/work/_temp/Library/haven/examples/iris.sas7bdat file is available in parquet format under /tmp/Rtmp0XSNj6/file18a7316584bc.parquet
#> Reading data...

# Conversion from a SAS file to a partitioned parquet file  :

table_to_parquet(
  path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
  path_to_parquet = tempfile(),
  partition = "yes",
  partitioning =  c("Species") # vector use as partition key
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp0XSNj6/file18a74806059d
#> Writing data...
#> Reading data...
#> ✔ The /home/runner/work/_temp/Library/haven/examples/iris.sas7bdat file is available in parquet format under /tmp/Rtmp0XSNj6/file18a74806059d
#> Reading data...

# Reading SAS file by chunk of 50 lines
# and conversion to multiple files with zstd, compression level 10

if (isTRUE(arrow::arrow_info()$capabilities[['zstd']])) {
  table_to_parquet(
    path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
    path_to_parquet = tempfile(),
    max_rows = 50,
    compression = "zstd",
    compression_level = 10
  )
}
#> Reading data...
#> Writing file18a721de1eec-1-50.parquet...
#> Reading data...
#> Writing file18a721de1eec-51-100.parquet...
#> Reading data...
#> Writing file18a721de1eec-101-150.parquet...
#> Reading data...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp0XSNj6/file18a721de1eec/
#> Reading data...
```
