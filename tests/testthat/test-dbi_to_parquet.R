dir.create("Data_test", showWarnings = FALSE)

dbi_connection <- DBI::dbConnect(RSQLite::SQLite(),
                                 system.file("extdata","iris.sqlite",package = "parquetize"))

test_that("Checks arguments are correctly filled in", {
  expect_error(
    dbi_to_parquet(
      sql_query = "SELECT * FROM iris",
      path_to_parquet = "Data_test",
      parquetname = "iris"
    ),
  class = "parquetize_missing_argument",
  regexp = "dbi_connection"
  )

  expect_error(
    dbi_to_parquet(
      dbi_connection = dbi_connection,
      path_to_parquet = "Data_test",
      parquetname = "iris"
    ),
    class = "parquetize_missing_argument",
    regexp = "sql_query"
  )

  expect_error(
    dbi_to_parquet(
      dbi_connection = dbi_connection,
      sql_query = "SELECT * FROM iris",
      parquetname = "iris"
    ),
    class = "parquetize_missing_argument",
    regexp = "path_to_parquet"
  )
})

test_that("Checks simple query generate a parquet file with good messages", {
  path_to_parquet <- "Data_test/dbi-simple"
  parquetname <- "iris"

  expect_snapshot(
    dbi_to_parquet(
      dbi_connection = dbi_connection,
      sql_query = "SELECT * FROM iris",
      path_to_parquet = path_to_parquet,
      parquetname = parquetname
    )
  )

  r <- arrow::read_parquet(file.path(path_to_parquet, paste0(parquetname, ".parquet")))
  expect_equal(nrow(r), 150)
})

test_that("Checks simple query generate a parquet file with good messages", {
  path_to_parquet <- "Data_test/dbi-partition-simple"
  parquetname <- "iris"

  expect_snapshot(
    dbi_to_parquet(
      dbi_connection = dbi_connection,
      sql_query = "SELECT * FROM iris WHERE `Petal.Width` = ?",
      sql_params = list(0.2),
      path_to_parquet = path_to_parquet,
      parquetname = parquetname,
      partition = "yes",
      partitioning = "Species"
    )
  )

  r <- arrow::open_dataset(path_to_parquet)
  expect_equal(nrow(r), 29)
})

test_that("Checks simple query generate a chunk parquet files with good messages", {
  path_to_parquet <- "Data_test/dbi-partition-chunked"
  parquetname <- "iris"

  expect_snapshot(
    dbi_to_parquet(
      dbi_connection = dbi_connection,
      sql_query = "SELECT * FROM iris WHERE [Petal.Width] = $width",
      sql_params = list(width = c(0.2)),
      path_to_parquet = path_to_parquet,
      parquetname = parquetname,
      chunk_memory_size = 2 / 1024
    )
  )

  r <- arrow::open_dataset(path_to_parquet)
  expect_equal(nrow(r), 29)
})


test_that("Checks simple query works by chunk", {
  path_to_parquet <- "Data_test/dbi-dataset"
  parquetname <- "iris"

  expect_snapshot(
    dbi_to_parquet(
      dbi_connection = dbi_connection,
      sql_query = "SELECT * FROM iris",
      path_to_parquet = path_to_parquet,
      chunk_size = 49
    )
  )

  r <- arrow::open_dataset(path_to_parquet)
  expect_equal(nrow(r), 150)
})

test_that("Checks query with params works", {
  dbi_to_parquet(
    dbi_connection = dbi_connection,
    sql_query = paste0("SELECT * FROM iris where Species = $species"),
    sql_params = list(species = c("virginica")),
    path_to_parquet = file.path("Data_test", "dbi-params", "Species=virginica"),
    chunk_size = 40
  )

  r <- arrow::open_dataset(file.path("Data_test/dbi-params"))
  expect_equal(nrow(r), 50)
})
