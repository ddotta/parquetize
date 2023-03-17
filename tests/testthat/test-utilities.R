test_that("test get_read_function_by_extension returns the good method", {
  file <- system.file("examples","iris.dta", package = "haven")
  fun <- get_read_function_for_file(file)
  expect_s3_class(fun(file), "tbl")

  file <- system.file("examples","iris.sas7bdat", package = "haven")
  fun <- get_read_function_for_file(file)
  expect_s3_class(fun(file), "tbl")

  file <- system.file("examples","iris.sav", package = "haven")
  fun <- get_read_function_for_file(file)
  expect_s3_class(fun(file), "tbl")
})


test_that("tests get_read_function_by_extension fails when needed", {
  expect_snapshot(
    get_read_function_for_file("/some/bad/file/without_extension"),
    error = TRUE
  )

  expect_snapshot(
    get_read_function_for_file("/some/bad/file/with_bad_extension"),
    error = TRUE
  )

  expect_snapshot(
    get_read_function_for_file("/some/bad/file/with_bad_extension.xlsx"),
    error = TRUE
  )
})

test_that("test get_lines_for_memory return the good number of lines", {
  file <- system.file("examples","iris.dta", package = "haven")

  expect_equal(
    get_lines_for_memory(file, chunk_memory_size = 1 / 1024),
    16
  )
})

