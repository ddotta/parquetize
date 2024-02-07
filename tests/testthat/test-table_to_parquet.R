skip_if_not_installed("arrow")

test_that("Checks arguments are filled in", {
  expect_missing_argument(
    table_to_parquet(
      path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
      encoding = "utf-8"
    ),
    regexp = "path_to_parquet"
  )

  expect_missing_argument(
    table_to_parquet(
      path_to_parquet = tempfile(),
      encoding = "utf-8"
    ),
    regexp = "path_to_file"
  )
})

test_that("Checks we can not use chunk_size with negative skip", {
  expect_error(
    table_to_parquet(
      path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      encoding = "utf-8",
      max_rows = 50,
      skip = -100
    ),
    class = "parquetize_bad_argument",
    regexp = "skip must be must be greater than"
  )
})

test_that("Checks by_chunk is deprecated", {
  expect_warning(
    table_to_parquet(
      path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      by_chunk = TRUE,
      max_rows = 50
    ),
    regexp = "This argument is no longer needed"
  )
})

test_that("Checks chunk_size and chunk_memory_size are deprecated", {
  expect_warning(
    table_to_parquet(
      path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      chunk_size = 1000
    ),
    regexp = "This argument is deprecated"
  )

  expect_warning(
    table_to_parquet(
      path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      chunk_memory_size = 1000
    ),
    regexp = "This argument is deprecated"
  )
})


test_that("Checks argument columns is a character vector", {
  expect_error(
    table_to_parquet(
      path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      columns = matrix(1:10)
    ),
    class = "parquetize_bad_type"
  )
})

test_that("Checks parquetizing all formats works and return files with the good number of lines", {
  for (extension in c("sas7bdat", "sav", "dta")) {
    path_to_parquet <- tempfile()
    file <- paste0("iris.", extension)

    expect_no_error(
      table_to_parquet(
        path_to_file = system.file("examples",file, package = "haven"),
        path_to_parquet = path_to_parquet
      )
    )

    expect_parquet(path_to_parquet, with_lines = 150)
  }
})

test_that("Checks parquetizing by chunk with encoding works", {
  path_to_parquet <- tempfile()

  expect_no_error(
    table_to_parquet(
      path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = path_to_parquet,
      max_rows = 50,
      encoding = "utf-8"
    )
  )

  expect_parquet(path_to_parquet, with_lines = 150, with_files = 3)
})

test_that("Checks parquetizing works with partitioning", {
  path_to_parquet <- tempfile()

  expect_no_error(
    table_to_parquet(
      path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = path_to_parquet,
      partition = "yes",
      partitioning =  "Species"
    )
  )
  expect_parquet(
    path_to_parquet,
    with_lines = 150,
    with_partitions = c("Species=setosa", "Species=versic", "Species=virgin")
  )

})

test_that("Checks it fails with SAS by adding max_rows, partition and partitioning argument", {
  expect_error(
    table_to_parquet(
      path_to_file = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      max_rows = 50,
      partition = "yes",
      partitioning =  "Species"
    ),
    class = "parquetize_bad_argument"
  )
})

test_that("Checks we have only selected columns in parquet file", {
  input_file <- system.file("examples","iris.sas7bdat", package = "haven")

  path_to_parquet <- tempfile()
  columns <- c("Species","Sepal_Length")

  table_to_parquet(
    path_to_file = input_file,
    path_to_parquet = path_to_parquet,
    columns = columns
  )

  expect_parquet(
    path_to_parquet,
    with_lines = 150,
    with_columns = columns
  )
})

test_that("Checks we have only selected columns in parquet dataset", {
  input_file <- system.file("examples","iris.sas7bdat", package = "haven")
  path_to_parquet <- tempfile()
  columns <- c("Species","Sepal_Length")

  table_to_parquet(
    path_to_file = input_file,
    path_to_parquet = path_to_parquet,
    columns = columns,
    max_rows = 50
  )

  expect_parquet(
    path_to_parquet,
    with_lines = 150,
    with_columns = columns
  )
})
