if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks arguments are correctly filled in", {
  expect_error(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.ndjson",package = "parquetize"),
      progressbar = "no"
    ),
    "Be careful, the argument path_to_parquet must be filled in"
  )
  expect_error(
    json_to_parquet(
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "Be careful, the argument path_to_json must be filled in"
  )
  expect_error(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.json",package = "parquetize"),
      path_to_parquet = "Data",
      format = "xjson",
      progressbar = "no"
    ),
    "Be careful, the argument format must be equal to 'json' or 'ndjson'"
  )
})

test_that("Checks message is displayed with json file", {
  expect_message(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.json",package = "parquetize"),
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "The json file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with ndjson file", {
  expect_message(
    json_to_parquet(
      path_to_json = system.file("extdata","iris.ndjson",package = "parquetize"),
      path_to_parquet = "Data",
      format = "ndjson",
      progressbar = "no"
    ),
    "The ndjson file is available in parquet format under Data"
  )
})
