skip_if_not_installed("arrow")
options(timeout=200)

test_that("Checks arguments are correctly filled in", {
  expect_missing_argument(
    csv_to_parquet(
      path_to_parquet = tempfile()
    ),
    regexp = "path_to_file"
  )

  expect_missing_argument(
    csv_to_parquet(
      path_to_file = parquetize_example("region_2022.csv")
    ),
    regexp = "path_to_parquet"
  )
})

test_that("Checks simple conversion works", {
  path_to_parquet <- tempfile()

  expect_no_error(
    csv_to_parquet(
      path_to_file = parquetize_example("region_2022.csv"),
      path_to_parquet = path_to_parquet
    )
  )

  expect_parquet(path = path_to_parquet, with_lines = 18)
})

test_that("Checks url_to_csv argument is deprecated", {
  expect_warning(
    csv_to_parquet(
      url_to_csv = "https://github.com/sidsriv/Introduction-to-Data-Science-in-python/raw/master/census.csv",
      path_to_parquet = tempfile()
    ),
    regexp = "deprecated"
  )
})
test_that("Checks csv_as_a_zip is deprecated", {
  expect_warning(
    csv_to_parquet(
      path_to_file = system.file("extdata","mtcars.csv.zip", package = "readr"),
      path_to_parquet = tempfile(),
      csv_as_a_zip = TRUE
    ),
    regexp = "deprecated"
  )
})


test_that("Checks it works with compression", {
  skip_if_offline()

  path_to_parquet <- tempfile()

  expect_no_error(
    csv_to_parquet(
      path_to_file = parquetize_example("region_2022.csv"),
      path_to_parquet = path_to_parquet,
      compression = "gzip",
      compression_level = 5
    )
  )

  expect_parquet(path = path_to_parquet, with_lines = 18)
})

test_that("Checks it works when partitioning", {
  path_to_parquet <- tempfile()

  expect_no_error(
    csv_to_parquet(
      path_to_file = parquetize_example("region_2022.csv"),
      path_to_parquet = path_to_parquet,
      partition = "yes",
      partitioning =  c("REG")
    )
  )

  expect_parquet(path = path_to_parquet, with_lines = 18)
})

test_that("Checks error if argument columns is not a character vector", {
  expect_error(
    csv_to_parquet(
      path_to_file = parquetize_example("region_2022.csv"),
      path_to_parquet = tempfile(),
      columns = matrix(1:10)
    ),
    class = "parquetize_bad_argument"
  )
})

test_that("Checks columns are selected as wanted", {
  path_to_parquet <- tempfile()
  columns <- c("REG","LIBELLE")

  expect_no_error(
    csv_to_parquet(
      path_to_file = parquetize_example("region_2022.csv"),
      path_to_parquet = path_to_parquet,
      columns = columns
    )
  )

  expect_parquet(
    path_to_parquet,
    with_lines = 18,
    with_columns = columns)
})

test_that("Checks message zip with one file works", {
  path_to_parquet <- tempfile()

  expect_no_error(
    csv_to_parquet(
      path_to_file = system.file("extdata","mtcars.csv.zip", package = "readr"),
      path_to_parquet = path_to_parquet,
    )
  )

  expect_parquet(path = path_to_parquet, with_lines = 32)
})


test_that("Checks we have only selected columns in parquet file", {
  path_to_parquet <- tempfile()
  columns <- c("REG","LIBELLE")

  csv_to_parquet(
    path_to_file = parquetize_example("region_2022.csv"),
    path_to_parquet = path_to_parquet,
    columns = columns
  )

  expect_setequal(
    names(arrow::read_parquet(path_to_parquet)),
    columns
  )
})


test_that("Checks error if csv starts with a comment", {
  expect_error(
    csv_to_parquet(
      path_to_file = parquetize_example("region_2022_with_comment.csv"),
      path_to_parquet = tempfile()
    ),
    regexp = 'Could not guess the delimiter'
  )
})


test_that("Checks conversion works with read_delim_args", {
  path_to_parquet <- tempfile()

  expect_no_error(
    csv_to_parquet(
      path_to_file = parquetize_example("region_2022_with_comment.csv"),
      path_to_parquet = path_to_parquet,
      read_delim_args = list(comment = '#')
    )
  )

  expect_parquet(path = path_to_parquet, with_lines = 18)
})
