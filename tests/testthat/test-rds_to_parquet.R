if (file.exists('Data_test')==FALSE) {
  dir.create("Data_test")
}

test_that("Checks arguments are correctly filled in", {
  expect_snapshot(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize")
    ),
    error = TRUE
  )
  expect_snapshot(
    rds_to_parquet(
      path_to_parquet = "Data_test"
    ),
    error = TRUE
  )
})

test_that("Checks message is displayed with rds file", {
  expect_snapshot(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      path_to_parquet = "Data_test"
    )
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_snapshot(
    rds_to_parquet(
      path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
      path_to_parquet = "Data_test",
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})
