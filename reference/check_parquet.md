# Check if parquet file or dataset is readable and return basic informations

This function checks if a file/dataset is a valid parquet format. It
will print the number of lines/columns and return a tibble on columns
information.

## Usage

``` r
check_parquet(path)
```

## Arguments

- path:

  path to the file or dataset

## Value

a tibble with information on parquet dataset/file's columns with three
columns : field name, arrow type and nullable

## Details

This function will :

- open the parquet dataset/file to check if it's valid

- print the number of lines

- print the number of columns

- return a tibble with 2 columns :

  - the column name (string)

  - the arrow type (string)

You can find a list of arrow type in the documentation [on this
page](https://arrow.apache.org/docs/r/articles/data_types.html).

## Examples

``` r
# check a parquet file
check_parquet(parquetize_example("iris.parquet"))
#> ℹ checking: /home/runner/work/_temp/Library/parquetize/extdata/iris.parquet
#> ✔ loading dataset:   ok
#> ✔ number of lines:   150
#> ✔ number of columns: 5
#> # A tibble: 5 × 2
#>   name         type      
#>   <chr>        <chr>     
#> 1 Sepal.Length double    
#> 2 Sepal.Width  double    
#> 3 Petal.Length double    
#> 4 Petal.Width  double    
#> 5 Species      dictionary

# check a parquet dataset
check_parquet(parquetize_example("iris_dataset"))
#> ℹ checking: /home/runner/work/_temp/Library/parquetize/extdata/iris_dataset
#> ✔ loading dataset:   ok
#> ✔ number of lines:   150
#> ✔ number of columns: 5
#> # A tibble: 5 × 2
#>   name         type  
#>   <chr>        <chr> 
#> 1 Sepal.Length double
#> 2 Sepal.Width  double
#> 3 Petal.Length double
#> 4 Petal.Width  double
#> 5 Species      utf8  
```
