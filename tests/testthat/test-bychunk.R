if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks bychunk works for SAS file", {

  test_data1 <- bychunk(file_format = "SAS", path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 0,
                       chunk_size = 50,
                       encoding = "utf-8")

  expect_equal(
    test_data1,
    TRUE)

  test_data2 <- bychunk(file_format = "SAS", path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 50,
                       chunk_size = 100,
                       encoding = "utf-8")

  expect_equal(
    test_data2,
    TRUE)

  test_data3 <- bychunk(file_format = "SAS", path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 100,
                       chunk_size = 150,
                       encoding = "utf-8")

  expect_equal(
    test_data3,
    TRUE)

  test_data4 <- bychunk(file_format = "SAS", path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 150,
                       chunk_size = 200,
                       encoding = "utf-8")

  expect_equal(
    test_data4,
    FALSE)

})

test_that("Checks bychunk works for SPSS file", {

  test_data1 <- bychunk(file_format = "SPSS", path_to_table = system.file("examples","iris.sav", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 0,
                       chunk_size = 50,
                       encoding = "utf-8")

  expect_equal(
    test_data1,
    TRUE)

  test_data2 <- bychunk(file_format = "SPSS", path_to_table = system.file("examples","iris.sav", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 50,
                       chunk_size = 100,
                       encoding = "utf-8")

  expect_equal(
    test_data2,
    TRUE)

  test_data3 <- bychunk(file_format = "SPSS", path_to_table = system.file("examples","iris.sav", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 100,
                       chunk_size = 150,
                       encoding = "utf-8")

  expect_equal(
    test_data3,
    TRUE)

  test_data4 <- bychunk(file_format = "SPSS", path_to_table = system.file("examples","iris.sav", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 150,
                       chunk_size = 200,
                       encoding = "utf-8")

  expect_equal(
    test_data4,
    FALSE)

})

test_that("Checks bychunk works for Stata file", {

  test_data1 <- bychunk(file_format = "Stata", path_to_table = system.file("examples","iris.dta", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 0,
                       chunk_size = 50,
                       encoding = "utf-8")

  expect_equal(
    test_data1,
    TRUE)

  test_data2 <- bychunk(file_format = "Stata", path_to_table = system.file("examples","iris.dta", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 50,
                       chunk_size = 100,
                       encoding = "utf-8")

  expect_equal(
    test_data2,
    TRUE)

  test_data3 <- bychunk(file_format = "Stata", path_to_table = system.file("examples","iris.dta", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 100,
                       chunk_size = 150,
                       encoding = "utf-8")

  expect_equal(
    test_data3,
    TRUE)

  test_data4 <- bychunk(file_format = "Stata", path_to_table = system.file("examples","iris.dta", package = "haven"),
                       path_to_parquet = "Data",
                       skip = 150,
                       chunk_size = 200,
                       encoding = "utf-8")

  expect_equal(
    test_data4,
    FALSE)

})
