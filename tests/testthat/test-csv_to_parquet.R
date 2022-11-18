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

test_that("Checks message is displayed", {
  expect_message(
    csv_to_parquet(
      url_to_csv = "https://stats.govt.nz/assets/Uploads/Research-and-development-survey/Research-and-development-survey-2021/Download-data/research-and-development-survey-2021-csv.csv",
      path_to_parquet = tempdir()
    ),
    paste0("The csv file is available in parquet format under ",tempdir())
  )
})
