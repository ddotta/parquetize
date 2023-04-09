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

test_that("check_parquet works on good dataset/file", {
  expect_snapshot(
    check_parquet(parquetize_example("iris_dataset")),
    transform = function(str) sub("(checking: ).*", "\\1", str)
  )

  expect_snapshot(
    check_parquet(parquetize_example("iris.parquet")),
    transform = function(str) sub("(checking: ).*", "", str)
  )
})
