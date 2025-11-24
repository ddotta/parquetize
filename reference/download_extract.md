# download and uncompress file if needed

This function will download the file if the file is remote and unzip it
if it is zipped. It will just return the input path argument if it's
neither.  

If the zip contains multiple files, you can use `filename_in_zip` to set
the file you want to unzip and use.

You can pipe output on all `*_to_parquet` functions.

## Usage

``` r
download_extract(path, filename_in_zip)
```

## Arguments

- path:

  the input file's path or url.

- filename_in_zip:

  name of the csv file in the zip. Required if several csv are included
  in the zip.

## Value

the path to the usable (uncompressed) file, invisibly.

## Examples

``` r
# 1. unzip a local zip file
# 2. parquetize it

file_path <- download_extract(system.file("extdata","mtcars.csv.zip", package = "readr"))
csv_to_parquet(
  file_path,
  path_to_parquet = tempfile(fileext = ".parquet")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a7750b6a95.parquet
#> Writing data...
#> Reading data...

# 1. download a remote file
# 2. extract the file census2021-ts007-ctry.csv
# 3. parquetize it

file_path <- download_extract(
  "https://www.nomisweb.co.uk/output/census/2021/census2021-ts007.zip",
  filename_in_zip = "census2021-ts007-ctry.csv"
)
csv_to_parquet(
  file_path,
  path_to_parquet = tempfile(fileext = ".parquet")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a7fb29efe.parquet
#> Writing data...
#> Reading data...

# the file is local and not zipped so :
# 1. parquetize it

file_path <- download_extract(parquetize_example("region_2022.csv"))
csv_to_parquet(
  file_path,
  path_to_parquet = tempfile(fileext = ".parquet")
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp0XSNj6/file18a76c5a4ff7.parquet
#> Writing data...
#> Reading data...
```
