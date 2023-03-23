# Checks arguments are correctly filled in

    Code
      csv_to_parquet(url_to_csv = "https://www.insee.fr/fr/statistiques/fichier/3568617/equip-tour-transp-infra-2021.zip")
    Message <cliMessage>
      x Be careful, the argument path_to_parquet must be filled in
    Error <simpleError>
      argument "path_to_parquet" is missing, with no default

---

    Code
      csv_to_parquet(path_to_parquet = "Data_test")
    Message <cliMessage>
      x Be careful, you have to fill in either the path_to_csv or url_to_csv argument
      Reading data...
    Error <simpleError>
      object 'csv_output' not found

# Checks message is displayed with path_to_csv argument

    Code
      csv_to_parquet(path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test")
    Message <cliMessage>
      Reading data...
      Writing data...
      v The csv file is available in parquet format under Data_test
      Writing data...

# Checks message is displayed with url_to_csv argument

    Code
      csv_to_parquet(url_to_csv = "https://github.com/sidsriv/Introduction-to-Data-Science-in-python/raw/master/census.csv",
        path_to_parquet = "Data_test")
    Message <cliMessage>
      Reading data...
      v The csv file is available in parquet format under Data_test
      Reading data...

# Checks message is displayed with url_to_csv argument and csv_as_a_zip as TRUE

    Code
      csv_to_parquet(url_to_csv = "https://www.stats.govt.nz/assets/Uploads/Business-employment-data/Business-employment-data-June-2022-quarter/Download-data/business-employment-data-june-2022-quarter-csv.zip",
        csv_as_a_zip = TRUE, filename_in_zip = "machine-readable-business-employment-data-june-2022-quarter.csv",
        path_to_parquet = "Data")
    Message <cliMessage>
      Reading data...
      v The csv file is available in parquet format under Data
      Reading data...

# Checks message is displayed with compression and compression_level arguments

    Code
      csv_to_parquet(path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test", compression = "gzip", compression_level = 5)
    Message <cliMessage>
      Reading data...
      Writing data...
      v The csv file is available in parquet format under Data_test
      Writing data...

# Checks message is displayed with by adding partition and partitioning argument

    Code
      csv_to_parquet(path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test", partition = "yes", partitioning = c("REG"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The csv file is available in parquet format under Data_test
      Writing data...

# Checks argument columns is a character vector

    Code
      csv_to_parquet(path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test", columns = matrix(1:10))
    Message <cliMessage>
      x Be careful, the argument columns must be a character vector
      Reading data...
    Error <rlang_error>
      Problem while evaluating `all_of(columns)`.
      Caused by error in `all_of()`:
      ! Can't subset elements.
      x Subscript must be a simple vector, not a matrix.

# Checks message is displayed when we select a few columns

    Code
      csv_to_parquet(path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test", columns = c("REG", "LIBELLE"))
    Message <cliMessage>
      Reading data...
      Writing data...
      v The csv file is available in parquet format under Data_test
      Writing data...

