# Checks arguments are correctly filled in

    Code
      rds_to_parquet(path_to_rds = system.file("extdata", "iris.rds", package = "parquetize"),
      progressbar = "no")
    Message <cliMessage>
      x Be careful, the argument path_to_parquet must be filled in
    Error <simpleError>
      argument "path_to_parquet" is missing, with no default

---

    Code
      rds_to_parquet(path_to_parquet = "Data", progressbar = "no")
    Message <cliMessage>
      x Be careful, the argument path_to_rds must be filled in
      Reading data...
    Error <simpleError>
      argument "path_to_rds" is missing, with no default

# Checks message is displayed with rds file

    Code
      rds_to_parquet(path_to_rds = system.file("extdata", "iris.rds", package = "parquetize"),
      path_to_parquet = "Data", progressbar = "no")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The rds file is available in parquet format under Data
      Writing data...

# Checks message is displayed with by adding partition and partitioning argument

    Code
      rds_to_parquet(path_to_rds = system.file("extdata", "iris.rds", package = "parquetize"),
      path_to_parquet = "Data", progressbar = "no", partition = "yes", partitioning = c(
        "Species"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The rds file is available in parquet format under Data
      Writing data...

