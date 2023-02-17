if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks arguments are correctly filled in", {
  expect_snapshot(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize")
    ),
    error = TRUE
  )
  expect_snapshot(
    sqlite_to_parquet(
      path_to_parquet = "Data"
    ),
    error = TRUE
  )
})

test_that("Checks message is displayed with sqlite file", {
  expect_snapshot(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      table_in_sqlite = "iris",
      path_to_parquet = "Data"
    )
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_snapshot(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      table_in_sqlite = "iris",
      path_to_parquet = "Data",
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})
