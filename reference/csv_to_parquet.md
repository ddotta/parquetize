# Convert a csv or a txt file to parquet format

This function allows to convert a csv or a txt file to parquet format.  

Two conversions possibilities are offered :

- Convert to a single parquet file. Argument `path_to_parquet` must then
  be used;

- Convert to a partitioned parquet file. Additionnal arguments
  `partition` and `partitioning` must then be used;

## Usage

``` r
csv_to_parquet(
  path_to_file,
  url_to_csv = lifecycle::deprecated(),
  csv_as_a_zip = lifecycle::deprecated(),
  filename_in_zip,
  path_to_parquet,
  columns = "all",
  compression = "snappy",
  compression_level = NULL,
  partition = "no",
  encoding = "UTF-8",
  read_delim_args = list(),
  ...
)
```

## Arguments

- path_to_file:

  String that indicates the path to the input file (don't forget the
  extension).

- url_to_csv:

  DEPRECATED use path_to_file instead

- csv_as_a_zip:

  DEPRECATED

- filename_in_zip:

  name of the csv/txt file in the zip. Required if several csv/txt are
  included in the zip.

- path_to_parquet:

  String that indicates the path to the directory where the parquet
  files will be stored.

- columns:

  Character vector of columns to select from the input file (by default,
  all columns are selected).

- compression:

  compression algorithm. Default "snappy".

- compression_level:

  compression level. Meaning depends on compression algorithm.

- partition:

  String ("yes" or "no" - by default) that indicates whether you want to
  create a partitioned parquet file. If "yes", `"partitioning"` argument
  must be filled in. In this case, a folder will be created for each
  modality of the variable filled in `"partitioning"`. Be careful, this
  argument can not be "yes" if `max_memory` or `max_rows` argument are
  not NULL.

- encoding:

  String that indicates the character encoding for the input file.

- read_delim_args:

  list of arguments for `read_delim`.

- ...:

  additional format-specific arguments, see
  [arrow::write_parquet()](https://arrow.apache.org/docs/r/reference/write_parquet.html)
  and
  [arrow::write_dataset()](https://arrow.apache.org/docs/r/reference/write_dataset.html)
  for more informations.

## Value

A parquet file, invisibly

## Note

Be careful, if the zip size exceeds 4 GB, the function may truncate the
data (because unzip() won't work reliably in this case - see
[here](https://rdrr.io/r/utils/unzip.html)). In this case, it's advised
to unzip your csv/txt file by hand (for example with
[7-Zip](https://www.7-zip.org/)) then use the function with the argument
`path_to_file`.

## Examples

``` r
# Conversion from a local csv file to a single parquet file :

csv_to_parquet(
  path_to_file = parquetize_example("region_2022.csv"),
  path_to_parquet = tempfile(fileext=".parquet")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a757be52c4.parquet
#> Writing data...
#> Reading data...

# Conversion from a local txt file to a single parquet file :

csv_to_parquet(
  path_to_file = parquetize_example("region_2022.txt"),
  path_to_parquet = tempfile(fileext=".parquet")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a77edcab10.parquet
#> Writing data...
#> Reading data...

# Conversion from a local csv file to a single parquet file and select only
# few columns :

csv_to_parquet(
  path_to_file = parquetize_example("region_2022.csv"),
  path_to_parquet = tempfile(fileext = ".parquet"),
  columns = c("REG","LIBELLE")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a7299613f3.parquet
#> Writing data...
#> Reading data...

# Conversion from a local csv file to a partitioned parquet file  :

csv_to_parquet(
  path_to_file = parquetize_example("region_2022.csv"),
  path_to_parquet = tempfile(fileext = ".parquet"),
  partition = "yes",
  partitioning =  c("REG")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet dataset under /tmp/Rtmp0XSNj6/file18a73380bd56.parquet
#> Writing data...
#> Reading data...

# Conversion from a URL and a zipped file (csv) :

csv_to_parquet(
  path_to_file = "https://www.nomisweb.co.uk/output/census/2021/census2021-ts007.zip",
  filename_in_zip = "census2021-ts007-ctry.csv",
  path_to_parquet = tempfile(fileext = ".parquet")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a7549e3fa8.parquet
#> Writing data...
#> Reading data...

if (FALSE) { # \dontrun{
# Conversion from a URL and a zipped file (txt) :

csv_to_parquet(
  path_to_file = "https://sourceforge.net/projects/irisdss/files/latest/download",
  filename_in_zip = "IRIS TEST data.txt",
  path_to_parquet = tempfile(fileext=".parquet")
)

# Conversion from a URL and a csv file with "gzip" compression :

csv_to_parquet(
  path_to_file =
  "https://github.com/sidsriv/Introduction-to-Data-Science-in-python/raw/master/census.csv",
  path_to_parquet = tempfile(fileext = ".parquet"),
  compression = "gzip",
  compression_level = 5
)
} # }
```
