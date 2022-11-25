if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks arguments are correctly filled in", {
  expect_error(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      progressbar = "no"
    ),
    "Be careful, the argument path_to_parquet must be filled in"
  )
  expect_error(
    rds_to_parquet(
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "Be careful, the argument path_to_rds must be filled in"
  )
})

test_that("Checks message is displayed with rds file", {
  expect_message(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "The rds file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_message(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      path_to_parquet = "Data",
      progressbar = "no",
      partition = "yes",
      partitioning =  c("Species")
    ),
    "The rds file is available in parquet format under Data"
  )
})
