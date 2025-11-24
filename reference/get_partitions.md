# get unique values from table's column

This function allows you to extract unique values from a table's column
to use as partitions.  

Internally, this function does "SELECT DISTINCT(`mycolumn`) FROM
`mytable`;"

## Usage

``` r
get_partitions(conn, table, column)
```

## Arguments

- conn:

  A `DBIConnection` object, as return by
  [`DBI::dbConnect`](https://dbi.r-dbi.org/reference/dbConnect.html)

- table:

  a DB table name

- column:

  a column name for the table passed in param

## Value

a vector with unique values for the column of the table

## Examples

``` r
dbi_connection <- DBI::dbConnect(RSQLite::SQLite(),
  system.file("extdata","iris.sqlite",package = "parquetize"))

get_partitions(dbi_connection, "iris", "Species")
#> [1] "setosa"     "versicolor" "virginica" 
```
