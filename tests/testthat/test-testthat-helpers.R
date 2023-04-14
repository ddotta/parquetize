test_that("expect_parquet fails on file error", {
  expect_error(
    expect_parquet(parquetize_example("region_2022.csv"), with_lines = 25),
    regexp = "Invalid"
  )
})

test_that("expect_parquet fails on file's number of line", {
  expect_error(
    expect_parquet(parquetize_example("iris_dataset"), with_lines = 25),
    regexp = "not equal"
  )
})

test_that("expect_parquet works without partitions", {
  expect_no_error(
    expect_parquet(parquetize_example("iris_dataset"), with_lines = 150)
  )
})

test_that("expect_parquet works with partitions", {
  expect_no_error(
    expect_parquet(parquetize_example("iris_dataset"),
                   with_lines = 150,
                   with_partitions = c('Species=setosa', 'Species=versicolor', 'Species=virginica'))
  )

  expect_no_error(
    expect_parquet(parquetize_example("iris_dataset"),
                   with_lines = 150,
                   with_partitions = )
  )
})

test_that("expect_parquet works with columns", {
  expect_no_error(
    expect_parquet(parquetize_example("iris_dataset"),
                   with_lines = 150,
                   with_columns = c("Petal.Width", "Sepal.Length", "Sepal.Width", "Species", "Petal.Length"))
  )
})

test_that("expect_parquet fails works with partitions", {
  expect_error(
    expect_parquet(parquetize_example("iris_dataset"),
                   with_lines = 150,
                   with_partitions = c('Species=setosa')),
    class = "partquetize_test_with_partitions"
  )
})

test_that("expect_parquet fails with bad columns columns", {
  expect_error(
    expect_parquet(parquetize_example("iris_dataset"),
                   with_lines = 150,
                   with_columns = c("Petal.Length", "Petal.Width", "Sepal.Length")),
    class = "partquetize_test_with_columns"
  )
})


test_that("expect_missing_argument check good errors", {
  raising_fun <- function() {
    cli_abort("string", class = "parquetize_missing_argument")
  }
  expect_no_error(
    expect_missing_argument(raising_fun(), regexp = "string")
  )
})

test_that("expect_missing_argument fails on bad string", {
  raising_fun <- function() {
    cli_abort("string", class = "parquetize_missing_argument")
  }
  expect_error(
    expect_missing_argument(raising_fun(), regexp = "message")
  )
})


test_that("expect_missing_argument fails on bad error type", {
  raising_fun <- function() {
    cli_abort("string", class = "a_class")
  }
  expect_error(
    expect_missing_argument(raising_fun(), regexp = "string"),
    class = "a_class"
  )
})
