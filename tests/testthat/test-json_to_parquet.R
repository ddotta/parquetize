if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks arguments are correctly filled in", {
  local_edition(3)
  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.ndjson",package = "parquetize")
    ),
    error = TRUE)
  expect_snapshot(
    json_to_parquet(
      path_to_parquet = "Data"
    ),
    error = TRUE)
  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.json",package = "parquetize"),
      path_to_parquet = "Data",
      format = "xjson"
    ),
    error = TRUE)
})

test_that("Checks message is displayed with json file", {
  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.json",package = "parquetize"),
      path_to_parquet = "Data"
    )
  )
})

test_that("Checks message is displayed with ndjson file", {
  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.ndjson",package = "parquetize"),
      path_to_parquet = "Data",
      format = "ndjson"
    )
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_snapshot(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.json",package = "parquetize"),
      path_to_parquet = "Data",
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})
