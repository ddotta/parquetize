if (file.exists('Data')==FALSE) {
  dir.create("Data_test")
}

test_that("Checks arguments are filled in", {
  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      encoding = "utf-8"
    ),
    error = TRUE
  )
  expect_snapshot(
    table_to_parquet(
      path_to_parquet = "Data_test",
      encoding = "utf-8"
    ),
    error = TRUE
  )
  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data_test",
      encoding = "utf-8",
      by_chunk = TRUE
    ),
    error = TRUE
  )
  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data_test",
      encoding = "utf-8",
      by_chunk = TRUE,
      chunk_size = 50,
      skip = -100
    ),
    error = TRUE
  )
})

test_that("Checks argument columns is a character vector", {

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data_test",
      columns = matrix(1:10)
    ),
    error = TRUE
  )
})

test_that("Checks message is displayed when we select a few columns", {

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data_test",
      columns = all_of(c("Species","Petal_Length"))
    )
  )

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sav", package = "haven"),
      path_to_parquet = "Data_test",
      columns = all_of(c("Species","Petal.Length"))
    )
  )

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.dta", package = "haven"),
      path_to_parquet = "Data_test",
      columns = all_of(c("species","petallength"))
    )
  )

})

test_that("Checks message is displayed with by adding chunk_size to TRUE and encoding argument", {

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data_test",
      by_chunk = TRUE,
      chunk_size = 50,
      encoding = "utf-8"
    )
  )
})

test_that("Checks message is displayed with by adding partition and partitioning argument", {

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data_test",
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})

test_that("Checks message is displayed with SAS by adding chunk_size, partition and partitioning argument", {

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data_test",
      by_chunk = TRUE,
      chunk_size = 50,
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})

test_that("Checks message is displayed with SAS by adding chunk_size argument", {

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
      path_to_parquet = "Data_test",
      by_chunk = TRUE,
      chunk_size = 50
    )
  )
})


test_that("Checks message is displayed with SPSS by adding nb_rows, partition and partitioning argument", {

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.sav", package = "haven"),
      path_to_parquet = "Data_test",
      partition = "yes",
      partitioning =  c("Species")
    )
  )
})

test_that("Checks message is displayed with Stata file and only path_to_table and path_to_parquet argument", {

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.dta", package = "haven"),
      path_to_parquet = "Data_test"
    )
  )
})

test_that("Checks message is displayed with Stata by adding partition and partitioning argument", {

  expect_snapshot(
    table_to_parquet(
      path_to_table = system.file("examples","iris.dta", package = "haven"),
      path_to_parquet = "Data_test",
      partition = "yes",
      partitioning =  c("species")
    )
  )
})
