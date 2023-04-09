test_that("Checks arguments are correctly filled in", {
  testthat::local_edition(3)

  expect_missing_argument(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.ndjson",package = "parquetize")
    ),
    regexp = "path_to_parquet"
  )

  expect_missing_argument(
    json_to_parquet(
      path_to_parquet = tempfile()
    ),
    regexp = "path_to_json"
  )

  expect_error(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.json",package = "parquetize"),
      path_to_parquet = tempfile(),
      format = "xjson"
    ),
    class = "parquetize_bad_format"
  )
})

test_that("Checks converting json file works", {
  path_to_parquet <- tempfile()

  json_to_parquet(
    path_to_json = system.file("extdata","iris.json",package = "parquetize"),
    path_to_parquet = path_to_parquet
  )

  expect_parquet(
    file.path(path_to_parquet, paste0("iris.parquet")),
    with_lines = 150
  )
})

test_that("Checks converting ndjson file works", {
  path_to_parquet <- tempfile()

  json_to_parquet(
    path_to_json = system.file("extdata","iris.ndjson",package = "parquetize"),
    path_to_parquet = path_to_parquet,
    format = "ndjson"
  )
  expect_parquet(
    file.path(path_to_parquet, paste0("iris.parquet")),
    with_lines = 150
  )

})

test_that("Checks adding partition and partitioning argument works", {
  path_to_parquet <- tempfile()

  json_to_parquet(
    path_to_json = system.file("extdata","iris.json",package = "parquetize"),
    path_to_parquet = path_to_parquet,
    partition = "yes",
    partitioning =  c("Species")
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
