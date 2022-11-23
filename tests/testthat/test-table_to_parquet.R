if (file.exists('Data')==FALSE) {
  dir.create("Data")
}

test_that("Checks arguments are filled in", {
  expect_error(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      encoding = "utf-8"
    ),
    "Be careful, the argument path_to_parquet must be filled in"
  )
  expect_error(
    table_to_parquet(
      path_to_parquet = "Data",
      encoding = "utf-8"
    ),
    "Be careful, the argument path_to_table must be filled in"
  )
})

test_that("Checks message is displayed with SAS file and only path_to_table and path_to_parquet argument", {

  expect_message(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "The SAS file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with by adding nb_rows and encoding argument", {

  expect_message(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data",
      nb_rows = 50,
      encoding = "utf-8"
    ),
    "The SAS file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_message(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data",
      partition = "yes",
      partitioning =  c("Species")
    ),
    "The SAS file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with SAS by adding nb_rows, partition and partitioning argument", {

  expect_message(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data",
      nb_rows = 50,
      partition = "yes",
      partitioning =  c("Species")
    ),
    "The SAS file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with SPSS file and only path_to_table and path_to_parquet argument", {

  expect_message(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sav", package = "haven"),
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "The SPSS file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with SPSS by adding nb_rows, partition and partitioning argument", {

  expect_message(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sav", package = "haven"),
      path_to_parquet = "Data",
      nb_rows = 50,
      partition = "yes",
      partitioning =  c("Species")
    ),
    "The SPSS file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with Stata file and only path_to_table and path_to_parquet argument", {

  expect_message(
    table_to_parquet(
      path_to_table = system.file("examples","iris.dta", package = "haven"),
      path_to_parquet = "Data",
      progressbar = "no"
    ),
    "The Stata file is available in parquet format under Data"
  )
})

test_that("Checks message is displayed with Stata by adding nb_rows, partition and partitioning argument", {

  expect_message(
    table_to_parquet(
      path_to_table = system.file("examples","iris.dta", package = "haven"),
      path_to_parquet = "Data",
      nb_rows = 50,
      partition = "yes",
      partitioning =  c("species")
    ),
    "The Stata file is available in parquet format under Data"
  )
})
