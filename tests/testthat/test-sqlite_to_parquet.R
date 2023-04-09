test_that("Checks arguments are correctly filled in", {
  expect_missing_argument(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize")
    ),
    regexp = "path_to_parquet"
  )
  expect_missing_argument(
    sqlite_to_parquet(
      path_to_parquet = tempfile()
    ),
    regexp = "path_to_sqlite"
  )
})

test_that("Check if extension used in path_to_sqlite is correct", {
  expect_error(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqliteee",package = "parquetize")
    ),
    class = "parquetize_bad_format"
  )
})

test_that("Check if parquetize fails when table does not exist", {
  expect_error(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      path_to_parquet = tempfile(),
      table = "nosuchtable"
    ),
    class = "parquetize_missing_table",
    regexp = "nosuchtable"
  )
})

test_that("Checks message is displayed with sqlite file", {
  path_to_parquet <- tempfile()

  expect_no_error(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      table_in_sqlite = "iris",
      path_to_parquet = path_to_parquet
    )
  )

  expect_parquet(
    file.path(path_to_parquet),
    with_lines = 150
  )

})

test_that("Checks message is displayed with by adding partition and partitioning argument", {
  path_to_parquet <- tempfile()

  expect_no_error(
    sqlite_to_parquet(
      path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
      table_in_sqlite = "iris",
      path_to_parquet = path_to_parquet,
      partition = "yes",
      partitioning =  c("Species")
    )
  )

  expect_parquet(
    file.path(path_to_parquet),
    with_lines = 150
  )

  expect_identical(
    dir(path_to_parquet),
    c('Species=setosa', 'Species=versicolor', 'Species=virginica')
  )

})
