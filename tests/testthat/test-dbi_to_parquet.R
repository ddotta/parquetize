dbi_connection <- DBI::dbConnect(RSQLite::SQLite(),
                                 system.file("extdata","iris.sqlite",package = "parquetize"))
on.exit(DBI::dbDisconnect(dbi_connection))

test_that("Checks arguments are correctly filled in", {
  expect_missing_argument(
    dbi_to_parquet(
      sql_query = "SELECT * FROM iris",
      path_to_parquet = "Data_test",
      parquetname = "iris"
    ),
  regexp = "conn"
  )

  expect_missing_argument(
    dbi_to_parquet(
      conn = dbi_connection,
      path_to_parquet = "Data_test",
      parquetname = "iris"
    ),
    regexp = "sql_query"
  )

  expect_missing_argument(
    dbi_to_parquet(
      conn = dbi_connection,
      sql_query = "SELECT * FROM iris",
      parquetname = "iris"
    ),
    regexp = "path_to_parquet"
  )
})

test_that("Checks simple query generate a parquet file", {
  path_to_parquet <- tempfile()
  parquetname <- "iris"

  expect_no_error(
    dbi_to_parquet(
      conn = dbi_connection,
      sql_query = "SELECT * FROM iris",
      path_to_parquet = path_to_parquet,
      parquetname = parquetname
    )
  )

  expect_parquet(
    file.path(path_to_parquet, paste0(parquetname, ".parquet")),
    with_lines = 150
  )
})

test_that("Checks simple query generate a parquet file with good messages", {
  path_to_parquet <- tempfile()
  parquetname <- "iris"

  expect_no_error(
    dbi_to_parquet(
      conn = dbi_connection,
      sql_query = "SELECT * FROM iris",
      path_to_parquet = path_to_parquet,
      parquetname = parquetname,
      partition = "yes",
      partitioning = "Species"
    )
  )

  expect_parquet(
    path_to_parquet,
    with_lines = 150,
    with_partitions = c("Species=setosa", "Species=versicolor", "Species=virginica")
  )
})

test_that("Checks simple query works by chunk with max_rows", {
  path_to_parquet <- tempfile()
  parquetname <- "iris"

  expect_no_error(
    dbi_to_parquet(
      conn = dbi_connection,
      sql_query = "SELECT * FROM iris",
      path_to_parquet = path_to_parquet,
      max_rows = 49
    )
  )

  expect_parquet(
    file.path(path_to_parquet),
    with_lines = 150
  )
})

test_that("Checks simple query works by chunk with max_memory", {
  path_to_parquet <- tempfile()
  parquetname <- "iris"

  expect_no_error(
    dbi_to_parquet(
      conn = dbi_connection,
      sql_query = "SELECT * FROM iris",
      path_to_parquet = path_to_parquet,
      max_memory = 2 / 1024
    )
  )

  expect_parquet(
    file.path(path_to_parquet),
    with_lines = 150
  )
})

