if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks arguments are correctly filled in", {
  gc()

  expect_error(
    duckdb_to_parquet(
      path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize"),
      progressbar = "no"
    ),
    "Be careful, the argument path_to_parquet must be filled in"
  )

  gc()

  expect_error(
    duckdb_to_parquet(
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "Be careful, the argument path_to_duckdb must be filled in"
  )

  gc()

  expect_error(
    duckdb_to_parquet(
      path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize"),
      table_in_duckdb = "mtcars",
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "Be careful, the table filled in the table_in_duckdb argument does not exist in your duckdb file"
  )

  gc()
})

test_that("Checks message is displayed with duckdb file", {
  gc()

  expect_message(
    duckdb_to_parquet(
      path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize"),
      table_in_duckdb = "iris",
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "The iris table from your duckdb file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  gc()

  expect_message(
    duckdb_to_parquet(
      path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize"),
      table_in_duckdb = "iris",
      path_to_parquet = "Data",
      progressbar = "no",
      partition = "yes",
      partitioning =  c("Species")
    ),
    "The iris table from your duckdb file is available in parquet format under Data"
  )
})

gc()
