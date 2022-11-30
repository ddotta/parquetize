if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks arguments are correctly filled in", {
  expect_error(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      progressbar = "no"
    ),
    "Be careful, the argument path_to_parquet must be filled in"
  )
  expect_error(
    sqlite_to_parquet(
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "Be careful, the argument path_to_sqlite must be filled in"
  )
  expect_error(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlit",package = "parquetize"),
      table_in_sqlite = "iris",
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "Be careful, the extension used in path_to_sqlite is not correct"
  )
  expect_error(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      table_in_sqlite = "mtcars",
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "Be careful, the table filled in the table_in_sqlite argument does not exist in your sqlite file"
  )
})

test_that("Checks message is displayed with sqlite file", {
  expect_message(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      table_in_sqlite = "iris",
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "The iris table from your sqlite file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_message(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      table_in_sqlite = "iris",
      path_to_parquet = "Data",
      progressbar = "no",
      partition = "yes",
      partitioning =  c("Species")
    ),
    "The iris table from your sqlite file is available in parquet format under Data"
  )
})
