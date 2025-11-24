# Get path to parquetize example

parquetize comes bundled with a number of sample files in its
`inst/extdata` directory. This function make them easy to access

## Usage

``` r
parquetize_example(file = NULL)
```

## Arguments

- file:

  Name of file or directory. If `NULL`, the example files will be
  listed.

## Value

A character string

## Examples

``` r
parquetize_example()
#>  [1] "iris.duckdb"                  "iris.fst"                    
#>  [3] "iris.json"                    "iris.ndjson"                 
#>  [5] "iris.parquet"                 "iris.rds"                    
#>  [7] "iris.sqlite"                  "iris_dataset"                
#>  [9] "multifile.zip"                "region_2022.csv"             
#> [11] "region_2022.txt"              "region_2022_with_comment.csv"
parquetize_example("region_2022.csv")
#> [1] "/home/runner/work/_temp/Library/parquetize/extdata/region_2022.csv"
parquetize_example("iris_dataset")
#> [1] "/home/runner/work/_temp/Library/parquetize/extdata/iris_dataset"
```
