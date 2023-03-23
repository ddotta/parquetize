if (file.exists('Data_test')==FALSE) {
  dir.create("Data_test")
}
options(timeout=200)

test_that("Checks arguments are correctly filled in", {
  expect_snapshot(
    csv_to_parquet(
      url_to_csv = "https://www.insee.fr/fr/statistiques/fichier/3568617/equip-tour-transp-infra-2021.zip"
    ),
    error = TRUE
  )
  expect_snapshot(
    csv_to_parquet(
      path_to_parquet = "Data_test"
    ),
    error = TRUE
  )
})

test_that("Checks message is displayed with path_to_csv argument", {
  expect_snapshot(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test"
    )
  )
})

test_that("Checks message is displayed with url_to_csv argument", {
  expect_snapshot(
    csv_to_parquet(
      url_to_csv = "https://github.com/sidsriv/Introduction-to-Data-Science-in-python/raw/master/census.csv",
      path_to_parquet = "Data_test"
    )
  )
})

test_that("Checks message is displayed with url_to_csv argument and csv_as_a_zip as TRUE", {
  expect_snapshot(
    csv_to_parquet(
      url_to_csv = "https://www.stats.govt.nz/assets/Uploads/Business-employment-data/Business-employment-data-June-2022-quarter/Download-data/business-employment-data-june-2022-quarter-csv.zip",
      csv_as_a_zip = TRUE,
      filename_in_zip = "machine-readable-business-employment-data-june-2022-quarter.csv",
      path_to_parquet = "Data"
    )
  )
})

test_that("Checks message is displayed with compression and compression_level arguments", {
  expect_snapshot(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test",
      compression = "gzip",
      compression_level = 5
    )
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_snapshot(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test",
      partition = "yes",
      partitioning =  c("REG")
    )
  )
})

test_that("Checks argument columns is a character vector", {

  expect_snapshot(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test",
      columns = matrix(1:10)
    ),
    error = TRUE
  )
})

test_that("Checks message is displayed when we select a few columns", {

  expect_snapshot(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = "Data_test",
      columns = c("REG","LIBELLE")
    )
  )

})

test_that("Checks we have only selected columns in parquet file", {
  input_file <- parquetize_example("region_2022.csv")
  parquet_file <- get_parquet_file_name(input_file)
  path_to_parquet <- "Data_test"
  columns <- c("REG","LIBELLE")

  csv_to_parquet(
    path_to_csv = input_file,
    path_to_parquet = path_to_parquet,
    columns = columns
  )

  expect_setequal(
    names(read_parquet(file.path(path_to_parquet, parquet_file))),
    columns
  )
})
