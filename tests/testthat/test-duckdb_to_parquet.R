if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks arguments are correctly filled in", {
  gc()

  expect_snapshot(
    duckdb_to_parquet(
      path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize")
    ),
    error = TRUE
  )

  gc()

  expect_snapshot(
    duckdb_to_parquet(
      path_to_parquet = "Data"
    ),
    error = TRUE
  )

  gc()

  expect_snapshot(
    duckdb_to_parquet(
      path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize"),
      table_in_duckdb = "mtcars",
      path_to_parquet = "Data"
    ),
    error = TRUE
  )

  gc()
})

test_that("Checks message is displayed with duckdb file", {
  gc()

  expect_snapshot(
    duckdb_to_parquet(
      path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize"),
      table_in_duckdb = "iris",
      path_to_parquet = "Data"
    )
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  gc()

  expect_snapshot(
    duckdb_to_parquet(
      path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize"),
      table_in_duckdb = "iris",
      path_to_parquet = "Data",
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})

gc()
