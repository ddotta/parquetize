if (file.exists('Data_test')==FALSE) {
  dir.create("Data_test")
}

test_that("Checks arguments are correctly filled in", {
  testthat::local_edition(3)
  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.ndjson",package = "parquetize")
    ),
    error = TRUE)
  expect_snapshot(
    json_to_parquet(
      path_to_parquet = "Data_test"
    ),
    error = TRUE)
  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.json",package = "parquetize"),
      path_to_parquet = "Data_test",
      format = "xjson"
    ),
    error = TRUE)
})

test_that("Checks message is displayed with json file", {
  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.json",package = "parquetize"),
      path_to_parquet = "Data_test"
    )
  )
})

test_that("Checks message is displayed with ndjson file", {
  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.ndjson",package = "parquetize"),
      path_to_parquet = "Data_test",
      format = "ndjson"
    )
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.json",package = "parquetize"),
      path_to_parquet = "Data_test",
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})
