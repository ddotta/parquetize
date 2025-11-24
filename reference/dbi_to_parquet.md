# Convert a SQL Query on a DBI connection to parquet format

This function allows to convert a SQL query from a DBI to parquet
format.  

It handles all DBI supported databases.

Two conversions possibilities are offered :

- Convert to a single parquet file. Argument `path_to_parquet` must then
  be used;

- Convert to a partitioned parquet file. Additionnal arguments
  `partition` and `partitioning` must then be used;

Examples explain how to convert a query to a chunked dataset

## Usage

``` r
dbi_to_parquet(
  conn,
  sql_query,
  path_to_parquet,
  max_memory,
  max_rows,
  chunk_memory_sample_lines = 10000,
  partition = "no",
  compression = "snappy",
  compression_level = NULL,
  ...
)
```

## Arguments

- conn:

  A DBIConnection object, as return by DBI::dbConnect

- sql_query:

  a character string containing an SQL query (this argument is passed to
  DBI::dbSendQuery)

- path_to_parquet:

  String that indicates the path to the directory where the parquet
  files will be stored.

- max_memory:

  Memory size (in Mb) in which data of one parquet file should roughly
  fit.

- max_rows:

  Number of lines that defines the size of the chunk. This argument can
  not be filled in if max_memory is used.

- chunk_memory_sample_lines:

  Number of lines to read to evaluate max_memory. Default to 10 000.

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
# Conversion from a sqlite dbi connection to a single parquet file :

dbi_connection <- DBI::dbConnect(RSQLite::SQLite(),
  system.file("extdata","iris.sqlite",package = "parquetize"))

# Reading iris table from local sqlite database
# and conversion to one parquet file :

dbi_to_parquet(
  conn = dbi_connection,
  sql_query = "SELECT * FROM iris",
  path_to_parquet = tempfile(fileext=".parquet"),
)
#> Reading data...
#> Writing data...
#> ✔ Data are available in parquet file under /tmp/Rtmp5JozyA/file1951342df525.parquet
#> Writing data...
#> Reading data...

# Reading iris table from local sqlite database by chunk (using
# `max_memory` argument) and conversion to multiple parquet files

dbi_to_parquet(
  conn = dbi_connection,
  sql_query = "SELECT * FROM iris",
  path_to_parquet = tempdir(),
  max_memory = 2 / 1024
)
#> Reading data...
#> Writing data in part-1-42.parquet...
#> Reading data...
#> Writing data in part-43-84.parquet...
#> Reading data...
#> Writing data in part-85-126.parquet...
#> Reading data...
#> Writing data in part-127-150.parquet...
#> ✔ Parquet dataset is available under /tmp/Rtmp5JozyA/
#> Writing data in part-127-150.parquet...

# Using chunk and partition together is not possible directly but easy to do :
# Reading iris table from local sqlite database by chunk (using
# `max_memory` argument) and conversion to arrow dataset partitioned by
# species

# get unique values of column "iris from table "iris"
partitions <- get_partitions(dbi_connection, table = "iris", column = "Species")

# loop over those values
for (species in partitions) {
  dbi_to_parquet(
    conn = dbi_connection,
    # use glue_sql to create the query filtering the partition
    sql_query = glue::glue_sql("SELECT * FROM iris where Species = {species}",
                               .con = dbi_connection),
    # add the partition name in the output dir to respect parquet partition schema
    path_to_parquet = file.path(tempdir(), "iris", paste0("Species=", species)),
    max_memory = 2 / 1024,
  )
}
#> Reading data...
#> Writing data in part-1-31.parquet...
#> Reading data...
#> Writing data in part-32-50.parquet...
#> ✔ Parquet dataset is available under /tmp/Rtmp5JozyA/iris/Species=setosa/
#> Writing data in part-32-50.parquet...
#> Reading data...
#> Writing data in part-1-31.parquet...
#> Reading data...
#> Writing data in part-32-50.parquet...
#> ✔ Parquet dataset is available under /tmp/Rtmp5JozyA/iris/Species=versicolor/
#> Writing data in part-32-50.parquet...
#> Reading data...
#> Writing data in part-1-31.parquet...
#> Reading data...
#> Writing data in part-32-50.parquet...
#> ✔ Parquet dataset is available under /tmp/Rtmp5JozyA/iris/Species=virginica/
#> Writing data in part-32-50.parquet...

# If you need a more complicated query to get your partitions, you can use
# dbGetQuery directly :
col_to_partition <- DBI::dbGetQuery(dbi_connection, "SELECT distinct(`Species`) FROM `iris`")[,1]
```
