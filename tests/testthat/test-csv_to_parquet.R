options(timeout=200)

test_that("Checks arguments are correctly filled in", {
  expect_missing_argument(
    csv_to_parquet(
      path_to_parquet = tempfile()
    ),
    regexp = "path_to_csv"
  )

  expect_missing_argument(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv")
    ),
    regexp = "path_to_parquet"
  )
})

test_that("Checks simple conversion works", {
  path_to_parquet <- tempfile()

  expect_no_error(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv"),
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
      path_to_csv = system.file("extdata","mtcars.csv.zip", package = "readr"),
      path_to_parquet = tempfile(),
      csv_as_a_zip = TRUE
    ),
    regexp = "deprecated"
  )
})


test_that("Checks it works with compression", {
  path_to_parquet <- tempfile()

  expect_no_error(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv"),
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
      path_to_csv = parquetize_example("region_2022.csv"),
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
      path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = tempfile(),
      columns = matrix(1:10)
    ),
    class = "parquetize_bad_argument"
  )
})

test_that("Checks columns are selected as wanted", {
  path_to_parquet <- tempfile()

  expect_no_error(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = path_to_parquet,
      columns = c("REG","LIBELLE")
    )
  )

  expect_parquet(path = path_to_parquet, with_lines = 18)
})

test_that("Checks message zip with one file works", {
  path_to_parquet <- tempfile()

  expect_no_error(
    csv_to_parquet(
      path_to_csv = system.file("extdata","mtcars.csv.zip", package = "readr"),
      path_to_parquet = path_to_parquet,
    )
  )

  expect_parquet(path = path_to_parquet, with_lines = 32)
})


test_that("Checks we have only selected columns in parquet file", {
  input_file <- parquetize_example("region_2022.csv")
  parquet_file <- get_parquet_file_name(input_file)
  path_to_parquet <- tempfile()
  columns <- c("REG","LIBELLE")

  csv_to_parquet(
    path_to_csv = input_file,
    path_to_parquet = path_to_parquet,
    columns = columns
  )

  expect_setequal(
    names(read_parquet(file.path(path_to_parquet, parquet_file))),
    columns
  )
})
