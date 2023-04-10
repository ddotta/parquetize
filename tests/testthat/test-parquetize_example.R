test_that("test number of sample files in the package positive", {
  expect_true(
    length(parquetize_example()) > 0
  )
})

test_that("test with file", {
  expect_no_error(
    parquetize_example("iris.json")
  )
})

test_that("test with directory without extension", {
  expect_no_error(
    parquetize_example("iris_dataset")
  )
})

test_that("test fails if file does not exist", {
  expect_error(
    parquetize_example("no_such_dataset"),
    class = "no_such_file"
  )
})
