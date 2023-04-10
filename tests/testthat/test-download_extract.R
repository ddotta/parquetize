test_that("Checks download_extract return local file if not a zip", {
  expect_equal(
    download_extract("/my/local/file.truc"),
    "/my/local/file.truc"
  )
})

test_that("Checks download_extract returns the csv file of local zip", {
  expect_match(
      download_extract(system.file("extdata","mtcars.csv.zip", package = "readr")),
    ".*/mtcars.csv"
  )
})

test_that("Checks download_extract fails with error if zip has more than one file and no filename_in_zip", {
  expect_missing_argument(
    download_extract(
      "https://www.insee.fr/fr/statistiques/fichier/3568617/equip-tour-transp-infra-2021.zip"
    ),
    regexp = "filename_in_zip"
  )
})

test_that("Checks download_extract returns the csv file of remote zip", {
  file <- download_extract(
    "https://www.stats.govt.nz/assets/Uploads/Business-employment-data/Business-employment-data-June-2022-quarter/Download-data/business-employment-data-june-2022-quarter-csv.zip"
  )

  expect_match(
    file,
    ".*/machine-readable-business-employment-data-june-2022-quarter.csv"
  )

  expect_true(
    file.exists(file)
  )
})

test_that("Checks download_extract fails with error if zip has more than one file and no filename_in_zip", {
  file <- download_extract(
    "https://www.insee.fr/fr/statistiques/fichier/3568617/equip-tour-transp-infra-2021.zip",
    filename_in_zip = "equip-tour-transp-infra-2021.csv"
  )

  expect_match(
    file,
    ".*/equip-tour-transp-infra-2021.csv"
  )

  expect_true(
    file.exists(file)
  )
})
