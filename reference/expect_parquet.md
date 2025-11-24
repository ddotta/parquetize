# Check if parquet dataset/file is readable and has the good number of rows

Check if parquet dataset/file is readable and has the good number of
rows

## Usage

``` r
expect_parquet(
  path,
  with_lines,
  with_partitions = NULL,
  with_columns = NULL,
  with_files = NULL
)
```

## Arguments

- path:

  to the parquet file or dataset

- with_lines:

  number of lines the file/dataset should have

- with_partitions:

  NULL or a vector with the partition names the dataset should have

- with_columns:

  NULL or a column's name vector the dataset/file should have

- with_files:

  NULL or number of files a dataset should have

## Value

the dataset handle
