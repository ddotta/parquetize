test_that("Checks read_by_chunk col imputation and col_name detection works for SAS file", {

  test_data <- read_by_chunk(format_export = "SAS",
                             path = system.file("examples","iris.sas7bdat", package = "haven"),
                             nb_rows = 50,
                             encoding = "utf-8")

  expect_equal(
    unname(unlist(lapply(test_data, class))),
    c("numeric", "numeric", "numeric", "numeric", "character")
  )
  expect_equal(names(test_data), c("Sepal_Length",
                                   "Sepal_Width",
                                   "Petal_Length",
                                   "Petal_Width",
                                   "Species"))

})

test_that("Checks read_by_chunk col imputation and col_name detection works for SPSS file", {

  test_data <- read_by_chunk(format_export = "SPSS",
                             path = system.file("examples","iris.sav", package = "haven"),
                             nb_rows = 50,
                             encoding = "utf-8")

  expect_equal(names(test_data), c("Sepal.Length",
                                   "Sepal.Width",
                                   "Petal.Length",
                                   "Petal.Width",
                                   "Species"))

})

test_that("Checks read_by_chunk col imputation and col_name detection works for Stata file", {

  test_data <- read_by_chunk(format_export = "Stata",
                             path = system.file("examples","iris.dta", package = "haven"),
                             nb_rows = 50,
                             encoding = "utf-8")

  expect_equal(
    unname(unlist(lapply(test_data, class))),
    c("numeric", "numeric", "numeric", "numeric", "character")
  )
  expect_equal(names(test_data), c("sepallength",
                                   "sepalwidth",
                                   "petallength",
                                   "petalwidth",
                                   "species"))

})
