test_that("check_parquet fails on bad file", {
  expect_error(
    check_parquet(parquetize_example("iris.sqlite")),
    regexp = "Error creating dataset"
  )
})

test_that("check_parquet fails on missing file", {
  expect_error(
    check_parquet("no_such_file"),
    class = "no_such_file"
  )
})
