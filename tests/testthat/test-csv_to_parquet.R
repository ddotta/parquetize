test_that("Checks arguments are filled in", {
  expect_error(
    csv_to_parquet(
      url_to_csv = "https://www.insee.fr/fr/statistiques/fichier/3568617/equip-tour-transp-infra-2021.zip"
    ),
    "Be careful, the argument path_to_parquet must be filled in"
  )
  expect_error(
    csv_to_parquet(
      path_to_parquet = "Data"
    ),
    "Be careful, you have to fill in either the path_to_csv or url_to_csv argument"
  )
})

test_that("Checks message is displayed with url_to_csv argument and csv_as_a_zip as TRUE", {
  expect_error(
    csv_to_parquet(
      url_to_csv = "https://www.stats.govt.nz/assets/Uploads/Business-employment-data/Business-employment-data-June-2022-quarter/Download-data/business-employment-data-june-2022-quarter-csv.zip",
      csv_as_a_zip = TRUE,
      path_to_parquet = tempdir()
    ),
    "Be careful, if the csv file is included in a zip then you must indicate the name of the csv file to convert"
  )
})

test_that("Checks message is displayed with path_to_csv argument", {
  expect_message(
    csv_to_parquet(
      path_to_csv = parquetize_example("region_2022.csv"),
      path_to_parquet = tempdir()
    ),
    paste0("The csv file is available in parquet format under ",tempdir())
  )
})

test_that("Checks message is displayed with url_to_csv argument", {
  expect_message(
    csv_to_parquet(
      url_to_csv = "https://stats.govt.nz/assets/Uploads/Research-and-development-survey/Research-and-development-survey-2021/Download-data/research-and-development-survey-2021-csv.csv",
      path_to_parquet = tempdir()
    ),
    paste0("The csv file is available in parquet format under ",tempdir())
  )
})

test_that("Checks message is displayed with url_to_csv argument and csv_as_a_zip as TRUE", {
  expect_message(
    csv_to_parquet(
      url_to_csv = "https://www.stats.govt.nz/assets/Uploads/Business-employment-data/Business-employment-data-June-2022-quarter/Download-data/business-employment-data-june-2022-quarter-csv.zip",
      csv_as_a_zip = TRUE,
      filename_in_zip = "machine-readable-business-employment-data-june-2022-quarter.csv",
      path_to_parquet = tempdir()
    ),
    paste0("The csv file is available in parquet format under ",tempdir())
  )
})
