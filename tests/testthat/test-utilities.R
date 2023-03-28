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
  read_method <- get_read_function_for_file(file)
  data <- read_method(file, n_max = Inf)

  expect_equal(
    get_lines_for_memory(data, chunk_memory_size = 1 / 1024),
    16
  )
})

test_that("test get_parquet_name_file works", {
  expect_equal(
    get_parquet_file_name("/path/file.csv"),
    "file.parquet"
  )

  expect_equal(
    get_parquet_file_name("/path/csv.csv"),
    "csv.parquet"
  )

})

test_that("test is_remote works", {
  expect_true(is_remote("https://my_url/"))
  expect_true(is_remote("http://my_url/"))
  expect_true(is_remote("ftp://my_url/"))
  expect_true(is_remote("ftps://my_url/"))

  expect_false(is_remote("c://my_url/"))
  expect_false(is_remote("/my_url/"))
})
