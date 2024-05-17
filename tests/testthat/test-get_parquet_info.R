test_that("get_parquet_info works for file", {
  parquet <- system.file("extdata", "iris.parquet", package = "parquetize")
  info <- get_parquet_info(parquet)

  expect_s3_class(info, "tbl")
  expect_equal(nrow(info), 1)
  expect_equal(ncol(info), 5)

  expect_equal(info[[1, "path"]], parquet)
  expect_equal(info[[1, "num_rows"]], 150)
  expect_equal(info[[1, "num_row_groups"]], 1)
  expect_equal(info[[1, "num_columns"]], 5)
  expect_equal(info[[1, "mean_row_group_size"]], 150)
})

test_that("get_parquet_info works for dataset", {
  parquet <- system.file("extdata", "iris_dataset", package = "parquetize")
  info <- get_parquet_info(parquet)

  expect_s3_class(info, "tbl")
  expect_equal(nrow(info), 3)
  expect_equal(ncol(info), 5)
})
