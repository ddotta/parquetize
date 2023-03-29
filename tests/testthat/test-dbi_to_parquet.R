dir.create("Data_test", showWarnings = FALSE)

dbi_connection <- DBI::dbConnect(RSQLite::SQLite(),
                                 system.file("extdata","iris.sqlite",package = "parquetize"))

expect_parquet_dataset <- function(file, with_lines) {
  r <- expect_no_error(arrow::open_dataset(file))
  expect_equal(nrow(r), with_lines)
}

expect_parquet_file <- function(file, with_lines) {
  r <- expect_no_error(arrow::read_parquet(file))
  expect_equal(nrow(r), with_lines)
}

test_that("Checks arguments are correctly filled in", {
  expect_missing_argument(
    dbi_to_parquet(
      sql_query = "SELECT * FROM iris",
      path_to_parquet = "Data_test",
      parquetname = "iris"
    ),
  regexp = "dbi_connection"
  )

  expect_missing_argument(
    dbi_to_parquet(
      dbi_connection = dbi_connection,
      path_to_parquet = "Data_test",
      parquetname = "iris"
    ),
    regexp = "sql_query"
  )

  expect_missing_argument(
    dbi_to_parquet(
      dbi_connection = dbi_connection,
      sql_query = "SELECT * FROM iris",
      parquetname = "iris"
    ),
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
    ),

  )

  expect_parquet(
    file.path(path_to_parquet, paste0(parquetname, ".parquet")),
    with_lines = 150
  )
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

  expect_parquet(
    path_to_parquet,
    with_lines = 29
  )
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

  expect_parquet(
    path_to_parquet,
    with_lines = 29
  )
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

  expect_parquet(
    file.path(path_to_parquet),
    with_lines = 150
  )
})

test_that("Checks query with params works", {
  dbi_to_parquet(
    dbi_connection = dbi_connection,
    sql_query = paste0("SELECT * FROM iris where Species = $species"),
    sql_params = list(species = c("virginica")),
    path_to_parquet = file.path("Data_test", "dbi-params", "Species=virginica"),
    chunk_size = 40
  )

  expect_parquet(
    file.path("Data_test/dbi-params"),
    with_lines = 50
  )
})
