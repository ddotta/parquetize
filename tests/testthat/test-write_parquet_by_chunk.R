# we create the closure to loop over the data.frame
my_read_closure <- function() {
  function(input, skip = 0L, n_max = Inf) {
    # if we are after the end of the input we return an empty data.frame
    if (skip+1 > nrow(input)) { return(data.frame()) }

    input[(skip+1):(min(skip+n_max, nrow(input))),]
  }
}

test_that("checks that argument works", {
  read_method <- my_read_closure()

  expect_missing_argument(
    write_parquet_by_chunk(
      input = mtcars,
      path_to_parquet = tempfile(),
      max_rows = 10,
    ),
    regexp = "read_method"
  )

  expect_missing_argument(
    write_parquet_by_chunk(
      read_method = read_method,
      path_to_parquet = tempfile(),
      max_rows = 10,
    ),
    regexp = "input"
  )

  expect_error(
    write_parquet_by_chunk(
      read_method = "",
      input = mtcars,
      path_to_parquet = tempfile(),
      max_rows = 10,
    ),
    regexp = "read_method",
    class = "parquetize_bad_argument"
  )

  expect_error(
    write_parquet_by_chunk(
      read_method = read_method,
      input = mtcars,
      path_to_parquet = tempfile(),
      max_rows = 10,
      max_memory = 10,
    ),
    regexp = "can not be used together",
    class = "parquetize_bad_argument"
  )
})

test_that("works with empty data", {
  path_to_parquet <- tempfile()
  read_method <- my_read_closure()

  expect_no_error(
    write_parquet_by_chunk(
      read_method = read_method,
      input = data.frame(),
      path_to_parquet = path_to_parquet,
      max_rows = 50,
    )
  )

  expect_parquet(path_to_parquet, with_lines = 0)
})

test_that("Checks parquetizing by nrow chunks works", {
  path_to_parquet <- tempfile()
  read_method <- my_read_closure()

  expect_no_error(
    write_parquet_by_chunk(
      read_method = read_method,
      input = iris,
      path_to_parquet = path_to_parquet,
      max_rows = 50,
    )
  )

  expect_parquet(path_to_parquet, with_lines = 150, with_files = 3)
})

test_that("Checks parquetizing by memory size chunks works", {
  path_to_parquet <- tempfile()
  read_method <- my_read_closure()

  expect_no_error(
    write_parquet_by_chunk(
      read_method = read_method,
      input = iris,
      path_to_parquet = path_to_parquet,
      max_memory = 2 / 1024,
    )
  )

  expect_parquet(path_to_parquet, with_lines = 150, with_files = 4)
})
