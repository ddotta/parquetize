# Checks arguments are filled in

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), encoding = "utf-8")
    Message <cliMessage>
      x Be careful, the argument path_to_parquet must be filled in
    Error <simpleError>
      argument "path_to_parquet" is missing, with no default

---

    Code
      table_to_parquet(path_to_parquet = "Data", encoding = "utf-8")
    Message <cliMessage>
      x Be careful, the argument path_to_table must be filled in
    Error <simpleError>
      argument "path_to_table" is missing, with no default

---

    Code
      table_to_parquet(path_to_parquet = "Data", encoding = "utf-8", by_chunk = TRUE)
    Message <cliMessage>
      x Be careful, the argument path_to_table must be filled in
      x Be careful, if you want to do a conversion by chunk then the argument chunk_size must be filled in
    Error <simpleError>
      argument "path_to_table" is missing, with no default

---

    Code
      table_to_parquet(path_to_parquet = "Data", encoding = "utf-8", by_chunk = TRUE,
        skip = -100)
    Message <cliMessage>
      x Be careful, the argument path_to_table must be filled in
      x Be careful, if you want to do a conversion by chunk then the argument chunk_size must be filled in
      x Be careful, if you want to do a conversion by chunk then the argument skip must be must be greater than 0
    Error <simpleError>
      argument "path_to_table" is missing, with no default

# Checks message is displayed with SAS file and only path_to_table and path_to_parquet argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data", )
    Message <cliMessage>
      Reading data...
      Writing data...
      v The SAS file is available in parquet format under Data
      Writing data...

# Checks message is displayed with by adding chunk_size to TRUE and encoding argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data", by_chunk = TRUE, chunk_size = 50,
      encoding = "utf-8")
    Message <cliMessage>
      v The SAS file is available in parquet format under Data/iris1-50.parquet
      v The SAS file is available in parquet format under Data/iris51-100.parquet
      v The SAS file is available in parquet format under Data/iris101-150.parquet

# Checks message is displayed with by adding partition and partitioning argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data", partition = "yes",
      partitioning = c("Species"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The SAS file is available in parquet format under Data
      Writing data...

# Checks message is displayed with SAS by adding chunk_size, partition and partitioning argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data", by_chunk = TRUE, chunk_size = 50,
      partition = "yes", partitioning = c("Species"))
    Message <cliMessage>
      v The SAS file is available in parquet format under Data/iris1-50.parquet
      v The SAS file is available in parquet format under Data/iris51-100.parquet
      v The SAS file is available in parquet format under Data/iris101-150.parquet

# Checks message is displayed with SAS by adding chunk_size argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sas7bdat",
        package = "haven"), path_to_parquet = "Data", by_chunk = TRUE, chunk_size = 50)
    Message <cliMessage>
      v The SAS file is available in parquet format under Data/iris1-50.parquet
      v The SAS file is available in parquet format under Data/iris51-100.parquet
      v The SAS file is available in parquet format under Data/iris101-150.parquet

# Checks message is displayed with SPSS by adding nb_rows, partition and partitioning argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.sav", package = "haven"),
      path_to_parquet = "Data", partition = "yes", partitioning = c("Species"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The SPSS file is available in parquet format under Data
      Writing data...

# Checks message is displayed with Stata file and only path_to_table and path_to_parquet argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.dta", package = "haven"),
      path_to_parquet = "Data")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The Stata file is available in parquet format under Data
      Writing data...

# Checks message is displayed with Stata by adding partition and partitioning argument

    Code
      table_to_parquet(path_to_table = system.file("examples", "iris.dta", package = "haven"),
      path_to_parquet = "Data", partition = "yes", partitioning = c("species"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The Stata file is available in parquet format under Data
      Writing data...

