if (file.exists('Data_test')==FALSE) {
  dir.create("Data_test")
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
      path_to_parquet = "Data_test"
    ),
    error = TRUE
  )
})

test_that("Check if extension used in path_to_sqlite is correct", {
  expect_snapshot(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqliteee",package = "parquetize")
    ),
    error = TRUE
  )
})

test_that("Checks message is displayed with sqlite file", {
  expect_snapshot(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      table_in_sqlite = "iris",
      path_to_parquet = "Data_test"
    )
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_snapshot(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      table_in_sqlite = "iris",
      path_to_parquet = "Data_test",
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})
