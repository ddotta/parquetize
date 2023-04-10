test_that("Checks arguments are filled in", {
  expect_missing_argument(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      encoding = "utf-8"
    ),
    regexp = "path_to_parquet"
  )

  expect_missing_argument(
    table_to_parquet(
      path_to_parquet = tempfile(),
      encoding = "utf-8"
    ),
    regexp = "path_to_table"
  )
})

test_that("Checks we can not use chunk_size with negative skip", {
  expect_error(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      encoding = "utf-8",
      chunk_size = 50,
      skip = -100
    ),
    class = "parquetize_bad_argument",
    regexp = "skip must be must be greater than"
  )
})

test_that("Checks we can't use chunk_size and chunk_memory_size together", {
  expect_error(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      chunk_size = 50,
      chunk_memory_size = 50
    ),
    class = "parquetize_bad_argument",
    regexp = "can not be used together"
  )
})

test_that("Checks by_chunk is deprecated", {
  expect_warning(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      by_chunk = TRUE
    ),
    regexp = "This argument is no longer needed"
  )
})

test_that("Checks argument columns is a character vector", {
  expect_error(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
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
        path_to_table = system.file("examples",file, package = "haven"),
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
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = path_to_parquet,
      chunk_size = 50,
      encoding = "utf-8"
    )
  )

  expect_parquet(path_to_parquet, with_lines = 150)
  expect_equal(length(dir(path_to_parquet)), 3, info = "we have 3 files")
})

test_that("Checks parquetizing by memory works", {
  path_to_parquet <- tempfile()

  expect_no_error(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = path_to_parquet,
      chunk_memory_size = 5 / 1024,
    )
  )
  expect_parquet(path_to_parquet, with_lines = 150)
})

test_that("Checks parquetizing works with partitioning", {
  path_to_parquet <- tempfile()

  expect_no_error(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
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

test_that("Checks it fails with SAS by adding chunk_size, partition and partitioning argument", {

  expect_error(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = tempfile(),
      chunk_size = 50,
      partition = "yes",
      partitioning =  "Species"
    ),
    class = "parquetize_bad_argument"
  )
})

test_that("Checks we have only selected columns in parquet file", {
  input_file <- system.file("examples","iris.sas7bdat", package = "haven")
  parquet_file <- get_parquet_file_name(input_file)
  path_to_parquet <- tempfile()
  columns <- c("Species","Sepal_Length")

  table_to_parquet(
    path_to_table = input_file,
    path_to_parquet = path_to_parquet,
    columns = columns
  )

  expect_setequal(
    names(read_parquet(file.path(path_to_parquet, parquet_file))),
    columns
  )
})
