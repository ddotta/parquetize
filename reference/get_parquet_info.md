# Get various info on parquet files

One very important parquet metadata is the row group size.  

If it's value is low (below 10 000), you should rebuild your parquet
files.  

Normal value is between 30 000 and 1 000 000

## Usage

``` r
get_parquet_info(path)
```

## Arguments

- path:

  parquet file path or directory. If directory is given,
  `get_parquet_info` will be applied on all parquet files found in
  subdirectories

## Value

a tibble with 5 columns :

- path, file path

- num_rows, number of rows

- num_row_groups, number of group row

- num_columns,

- row_group_size, mean row group size

If one column contain `NA`, parquet file may be malformed.

## Examples

``` r
get_parquet_info(system.file("extdata", "iris.parquet", package = "parquetize"))
#> # A tibble: 1 × 5
#>   path                   num_rows num_row_groups num_columns mean_row_group_size
#>   <chr>                     <int>          <int>       <int>               <dbl>
#> 1 /home/runner/work/_te…      150              1           5                 150

get_parquet_info(system.file("extdata", "iris_dataset", package = "parquetize"))
#> # A tibble: 3 × 5
#>   path                   num_rows num_row_groups num_columns mean_row_group_size
#>   <chr>                     <int>          <int>       <int>               <dbl>
#> 1 /home/runner/work/_te…       50              1           4                  50
#> 2 /home/runner/work/_te…       50              1           4                  50
#> 3 /home/runner/work/_te…       50              1           4                  50
```
