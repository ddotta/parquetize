test_that("Checks arguments are correctly filled in", {
  expect_missing_argument(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize")
    ),
    regexp = "path_to_parquet"
  )
  expect_missing_argument(
    rds_to_parquet(
      path_to_parquet = tempfile()
    ),
    regexp = "path_to_rds"
  )
})

test_that("Checks message is displayed with rds file", {
  path_to_parquet <- tempfile()

  expect_no_error(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      path_to_parquet = path_to_parquet
    )
  )
  expect_parquet(
    file.path(path_to_parquet),
    with_lines = 150
  )

})

test_that("Checks message is displayed with by adding partition and partitioning argument", {
  path_to_parquet <- tempfile()

  expect_no_error(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      path_to_parquet = path_to_parquet,
      partition = "yes",
      partitioning =  c("Species")
    )
  )

  expect_parquet(
    file.path(path_to_parquet),
    with_lines = 150
  )
  expect_identical(
    dir(path_to_parquet),
    c('Species=setosa', 'Species=versicolor', 'Species=virginica')
  )
})
