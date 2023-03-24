#' download file and uncompress if needed
#'
#' This method will download the file or use the local file
#'
#' If the file is a zip it :
#'
#' * returns the file if zip is only one file
#' * returns filename_in_zip if there's more than one file
#'
#' If the file is not a zip it returns immediately the path argument.
#'
#' @param path the input file
#' @param filename_in_zip name of the csv file in the zip. Required if several csv are included in the zip.
#'
#' @return the name of a file
#' @export
#'
#' @examples
#'
#' download_extract(system.file("extdata","mtcars.csv.zip", package = "readr"))
#'
#' download_extract(
#'   "https://www.nomisweb.co.uk/output/census/2021/census2021-ts007.zip",
#'   filename_in_zip = "census2021-ts007-ctry.csv"
#' )
#'
#' download_extract("/my/local/file.csv")
#'
download_extract <- function(path, filename_in_zip) {
  if (!is_zip(path)) return(path)

  if (is_remote(path)) {
    zip_file <- curl_download(path,tempfile())
  } else {
    zip_file <- path
  }

  csv_files <- unzip(zipfile=zip_file,exdir=tempfile())
  names(csv_files) <- sub('.*/', '', csv_files)

  if (length(csv_files) > 1 & missing(filename_in_zip)) {
    cli_alert_danger("Be careful, zip files contains more than one file, you must set filename_in_zip argument")
    stop("")
  } else if (length(csv_files) > 1) {
    path <- csv_files[[filename_in_zip]]
  } else {
    path <- csv_files[[1]]
  }
  path
}

