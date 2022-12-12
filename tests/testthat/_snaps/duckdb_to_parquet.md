# Checks arguments are correctly filled in

    Code
      duckdb_to_parquet(path_to_duckdb = system.file("extdata", "iris.duckdb",
        package = "parquetize"), progressbar = "no")
    Message <cliMessage>
      x Be careful, the argument path_to_parquet must be filled in
    Error <simpleError>
      argument "path_to_parquet" is missing, with no default

---

    Code
      duckdb_to_parquet(path_to_parquet = "Data", progressbar = "no")
    Message <cliMessage>
      x Be careful, the argument path_to_duckdb must be filled in
      Reading data...
    Error <simpleError>
      argument "path_to_duckdb" is missing, with no default

---

    Code
      duckdb_to_parquet(path_to_duckdb = system.file("extdata", "iris.duckdb",
        package = "parquetize"), table_in_duckdb = "mtcars", path_to_parquet = "Data",
      progressbar = "no")
    Message <cliMessage>
      Reading data...
      x Be careful, the table filled in the table_in_duckdb argument does not exist in your duckdb file
      Reading data...
    Error <simpleError>
      rapi_prepare: Failed to prepare query SELECT * FROM mtcars
      Error: Catalog Error: Table with name mtcars does not exist!
      Did you mean "iris"?
      LINE 1: SELECT * FROM mtcars
                            ^

# Checks message is displayed with duckdb file

    Code
      duckdb_to_parquet(path_to_duckdb = system.file("extdata", "iris.duckdb",
        package = "parquetize"), table_in_duckdb = "iris", path_to_parquet = "Data")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The iris table from your duckdb file is available in parquet format under Data
      Writing data...

# Checks message is displayed with by adding partition and partitioning argument

    Code
      duckdb_to_parquet(path_to_duckdb = system.file("extdata", "iris.duckdb",
        package = "parquetize"), table_in_duckdb = "iris", path_to_parquet = "Data",
      progressbar = "no", partition = "yes", partitioning = c("Species"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The iris table from your duckdb file is available in parquet format under Data
      Writing data...

