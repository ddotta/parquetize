if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks arguments are correctly filled in", {
  expect_snapshot(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      progressbar = "no"
    ),
    error = TRUE
  )
  expect_snapshot(
    rds_to_parquet(
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    error = TRUE
  )
})

test_that("Checks message is displayed with rds file", {
  expect_snapshot(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      path_to_parquet = "Data",
      progressbar = "no"
    )
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_snapshot(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      path_to_parquet = "Data",
      progressbar = "no",
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})
