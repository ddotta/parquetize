if (file.exists('Data_test')==FALSE) {
  dir.create("Data_test")
}
options(timeout=200)

test_that("Checks arguments are correctly filled in", {
  expect_snapshot(
    csv_to_parquet(
      path_to_parquet = "Data_test"
    ),
    error = TRUE
  )
  expect_snapshot(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv")
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

test_that("Checks message is displayed when we use a local csv.zip without filename_in_zip", {

  expect_snapshot(
    csv_to_parquet(
      path_to_csv = system.file("extdata","mtcars.csv.zip", package = "readr"),
      path_to_parquet = "Data_test",
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
