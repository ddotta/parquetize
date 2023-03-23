# Checks arguments are correctly filled in

    Code
      sqlite_to_parquet(path_to_sqlite = system.file("extdata", "iris.sqlite",
        package = "parquetize"))
    Message <cliMessage>
      x Be careful, the argument path_to_parquet must be filled in
    Error <simpleError>
      argument "path_to_parquet" is missing, with no default

---

    Code
      sqlite_to_parquet(path_to_parquet = "Data_test")
    Message <cliMessage>
      x Be careful, the argument path_to_sqlite must be filled in
    Error <simpleError>
      argument "path_to_sqlite" is missing, with no default

# Check if extension used in path_to_sqlite is correct

    Code
      sqlite_to_parquet(path_to_sqlite = system.file("extdata", "iris.sqliteee",
        package = "parquetize"))
    Message <cliMessage>
      x Be careful, the extension used in path_to_sqlite is not correct
      x Be careful, the argument path_to_parquet must be filled in
    Error <simpleError>
      argument "path_to_parquet" is missing, with no default

# Check if parquetize fails when table does not exist

    Code
      sqlite_to_parquet(path_to_sqlite = system.file("extdata", "iris.sqlite",
        package = "parquetize"), path_to_parquet = "Data_test", table = "nosuchtable")
    Message <cliMessage>
      Reading data...
      x Be careful, the table filled in the table_in_sqlite argument does not exist in your sqlite file
      Reading data...
    Error <simpleError>
      

# Checks message is displayed with sqlite file

    Code
      sqlite_to_parquet(path_to_sqlite = system.file("extdata", "iris.sqlite",
        package = "parquetize"), table_in_sqlite = "iris", path_to_parquet = "Data_test")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The iris table from your sqlite file is available in parquet format under Data_test
      Writing data...

# Checks message is displayed with by adding partition and partitioning argument

    Code
      sqlite_to_parquet(path_to_sqlite = system.file("extdata", "iris.sqlite",
        package = "parquetize"), table_in_sqlite = "iris", path_to_parquet = "Data_test",
      partition = "yes", partitioning = c("Species"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The iris table from your sqlite file is available in parquet format under Data_test
      Writing data...

