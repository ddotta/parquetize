test_that("Checks rbind_parquet creates correct output file", {

  if (file.exists('output')==FALSE) {
    dir.create("output")
  }

  file.create(fileext = "output/test_data1-4.parquet")
  write_parquet(data.frame(
    x = c("a","b","c"),
    y = c(1L,2L,3L)
  ),
  "output/test_data1-4.parquet")

  file.create(fileext = "output/test_data4-6.parquet")
  write_parquet(data.frame(
    x = c("d","e","f"),
    y = c(4L,5L,6L)
  ), "output/test_data4-6.parquet")

  test_data <- rbind_parquet(folder = "output",
                             output_name = "test_data",
                             delete_initial_files = FALSE)

  expect_equal(
    unname(unlist(lapply(test_data, class))),
    c("character", "integer")
  )

  expect_equal(names(test_data), c("x",
                                   "y"))

})
