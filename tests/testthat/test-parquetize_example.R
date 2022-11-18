test_that("test number of sample files in the package positive", {
  expect_true(
    length(parquetize_example()) > 0
  )
})
