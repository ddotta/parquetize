#' @name download_extract
#'
#' @title download and uncompress file if needed
#'
#' @description This function will download the file if the file is remote and
#'   unzip it if it is zipped.  It will just return the input path argument if
#'   it's neither. \cr
#'
#' If the zip contains multiple files, you can use `filename_in_zip` to set the file you want to unzip and use.
#'
#' You can pipe output on all `*_to_parquet` functions.
#'
#'
#' @param path the input  file's path or url.
#' @param filename_in_zip name of the csv file in the zip. Required if
#'   several csv are included in the zip.
#'
#' @return the path to the usable (uncompressed) file, invisibly.
#'
#' @importFrom tools file_ext
#' @export
#'
#' @examples
#'
#' # 1. unzip a local zip file
#' # 2. parquetize it
#'
#' file_path <- download_extract(system.file("extdata","mtcars.csv.zip", package = "readr"))
#' csv_to_parquet(
#'   file_path,
#'   path_to_parquet = tempfile(fileext = ".parquet")
#' )
#'
#' # 1. download a remote file
#' # 2. extract the file census2021-ts007-ctry.csv
#' # 3. parquetize it
#'
#' file_path <- download_extract(
#'   "https://www.nomisweb.co.uk/output/census/2021/census2021-ts007.zip",
#'   filename_in_zip = "census2021-ts007-ctry.csv"
#' )
#' csv_to_parquet(
#'   file_path,
#'   path_to_parquet = tempfile(fileext = ".parquet")
#' )
#'
#' # the file is local and not zipped so :
#' # 1. parquetize it
#'
#' file_path <- download_extract(parquetize_example("region_2022.csv"))
#' csv_to_parquet(
#'   file_path,
#'   path_to_parquet = tempfile(fileext = ".parquet")
#' )
#'
download_extract <- function(path, filename_in_zip) {
  if (is_remote(path)) {
    tmp_file <- curl_download(path,tempfile(fileext = file_ext(path)))
  } else {
    tmp_file <- path
  }

  if (!is_zip(path)) return(invisible(tmp_file))

  csv_files <- unzip(zipfile=tmp_file,exdir=tempfile())
  names(csv_files) <- basename(csv_files)

  if (length(csv_files) > 1 & missing(filename_in_zip)) {
    cli_abort("Be careful, zip files contains more than one file, you must set filename_in_zip argument",
              class = "parquetize_missing_argument")
  } else if (length(csv_files) > 1) {
    path <- csv_files[[filename_in_zip]]
  } else {
    path <- csv_files[[1]]
  }
  invisible(path)
}

