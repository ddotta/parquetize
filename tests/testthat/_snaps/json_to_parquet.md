# Checks arguments are correctly filled in

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.ndjson", package = "parquetize"))
    Message <cliMessage>
      x Be careful, the argument path_to_parquet must be filled in
    Error <simpleError>
      argument "path_to_parquet" is missing, with no default

---

    Code
      json_to_parquet(path_to_parquet = "Data")
    Message <cliMessage>
      x Be careful, the argument path_to_json must be filled in
      Reading data...
    Error <simpleError>
      argument "path_to_json" is missing, with no default

---

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.json", package = "parquetize"),
      path_to_parquet = "Data", format = "xjson")
    Message <cliMessage>
      x Be careful, the argument format must be equal to 'json' or 'ndjson'
      Reading data...
      Writing data...
    Error <simpleError>
      object 'json_output' not found

# Checks message is displayed with json file

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.json", package = "parquetize"),
      path_to_parquet = "Data")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The json file is available in parquet format under Data
      Writing data...

# Checks message is displayed with ndjson file

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.ndjson", package = "parquetize"),
      path_to_parquet = "Data", format = "ndjson")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The ndjson file is available in parquet format under Data
      Writing data...

# Checks message is displayed with by adding partition and partitioning argument

    Code
      json_to_parquet(path_to_json = system.file("extdata", "iris.json", package = "parquetize"),
      path_to_parquet = "Data", partition = "yes", partitioning = c("Species"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The json file is available in parquet format under Data
      Writing data...

