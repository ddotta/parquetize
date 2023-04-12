dbi_connection <- DBI::dbConnect(RSQLite::SQLite(),
                                 system.file("extdata","iris.sqlite",package = "parquetize"))
on.exit(DBI::dbDisconnect(dbi_connection))

test_that("Checks get_partitions returns the good value", {
  partitions <- expect_no_error(
    get_partitions(
      conn = dbi_connection,
      table = "iris",
      column = "Species"
    ),
  )

  testthat::expect_setequal(partitions, c("setosa", "versicolor", "virginica"))
})

test_that("Checks arguments are correctly filled in", {
  expect_missing_argument(
    get_partitions(
      table = "iris",
      column = "Species"
    ),
    regexp = "conn"
  )
  expect_missing_argument(
    get_partitions(
      conn = dbi_connection,
      column = "Species"
    ),
    regexp = "table"
  )
  expect_missing_argument(
    get_partitions(
      conn = dbi_connection,
      table = "iris",
    ),
    regexp = "column"
  )
})

