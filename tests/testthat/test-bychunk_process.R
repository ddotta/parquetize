test_that("Checks bychunk_process creates correct output file", {

  if (file.exists('output')==FALSE) {
    dir.create("output")
  }

  file.create(fileext = "output/parquetize0.parquet")
  write_parquet(data.frame(
    x = c("a","b","c"),
    y = c(1L,2L,3L)
  ),
  "output/parquetize0.parquet")

  file.create(fileext = "output/parquetize500000.parquet")
  write_parquet(data.frame(
    x = c("d","e","f"),
    y = c(4L,5L,6L)
  ), "output/parquetize500000.parquet")

  test_data <- bychunk_process(folder = "output", output_name = "test_data.parquet")


  expect_equal(
    unname(unlist(lapply(test_data, class))),
    c("character", "integer")
  )

  expect_equal(names(test_data), c("x",
                                   "y"))

})
