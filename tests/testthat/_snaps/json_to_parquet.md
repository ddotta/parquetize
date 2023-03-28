# Checks arguments are correctly filled in

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.ndjson", package = "parquetize"))
    Message <cliMessage>
      x Be careful, the argument path_to_parquet must be filled in
    Error <simpleError>
      

---

    Code
      json_to_parquet(path_to_parquet = "Data_test")
    Message <cliMessage>
      x Be careful, the argument path_to_json must be filled in
    Error <simpleError>
      

---

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.json", package = "parquetize"),
      path_to_parquet = "Data_test", format = "xjson")
    Message <cliMessage>
      x Be careful, the argument format must be equal to 'json' or 'ndjson'
    Error <simpleError>
      

# Checks message is displayed with json file

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.json", package = "parquetize"),
      path_to_parquet = "Data_test")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The json file is available in parquet format under Data_test
      Writing data...

# Checks message is displayed with ndjson file

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.ndjson", package = "parquetize"),
      path_to_parquet = "Data_test", format = "ndjson")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The ndjson file is available in parquet format under Data_test
      Writing data...

# Checks message is displayed with by adding partition and partitioning argument

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.json", package = "parquetize"),
      path_to_parquet = "Data_test", partition = "yes", partitioning = c("Species"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The json file is available in parquet format under Data_test
      Writing data...

