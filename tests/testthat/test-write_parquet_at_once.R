skip_if_not_installed("arrow")

test_that("write_parquet_at_once warn if path_to_parquet is a directory for a parquet file", {
  path_to_parquet <- tempfile()
  dir.create(path_to_parquet, showWarnings = FALSE)
  expect_message(
    write_parquet_at_once(mtcars, path_to_parquet = path_to_parquet, partition = "no"),
    regexp = "path_to_parquet should be a file name"
  )
})

test_that("write_parquet_at_once fails on missing argument", {
  expect_missing_argument(
    write_parquet_at_once(
      path_to_parquet = path_to_parquet
      ),
    regexp = "data"
  )

  expect_missing_argument(
    write_parquet_at_once(
      data = iris
    ),
    regexp = "path_to_parquet"
  )
})

test_that("write_parquet_at_once works for simple parquet file", {
  path_to_parquet <- tempfile()
  expect_no_error(
    write_parquet_at_once(iris, path_to_parquet)
  )

  expect_parquet(
    path_to_parquet,
    with_lines = 150,
    with_file = 1
  )
})

test_that("write_parquet_at_once works for partitioned dataset", {
  path_to_parquet <- tempfile()
  expect_no_error(
    write_parquet_at_once(iris, path_to_parquet, partition = "yes", partitioning = "Species")
  )

  expect_parquet(
    path_to_parquet,
    with_lines = 150,
    with_file = 3,
    with_partitions = c("Species=setosa", "Species=versicolor", "Species=virginica")
  )
})
