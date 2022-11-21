#' Convert a csv table to parquet format
#'
#' This function allows to convert a csv table to parquet format. \cr
#'
#' Several conversion possibilities are offered :
#'
#'\itemize{
#'
#' \item{From a locally stored file. The argument `path_to_csv` must then be used;}
#' \item{From a URL. The argument `url_to_csv` must then be used.}
#'
#' }
#'
#' @param path_to_csv string that indicates the path to the csv file
#' @param url_to_csv string that indicates the URL of the csv file
#' @param csv_as_a_zip boolean that indicates if the csv is stored in a zip
#' @param filename_in_zip name of the csv file in the zip (useful if several csv are included in the zip). Required if `csv_as_a_zip` is TRUE.
#' @param path_to_parquet string that indicates the path to the directory where the parquet file will be stored
#' @param compression_type string that indicates the compression type for the parquet file (see here \url{https://arrow.apache.org/docs/r/reference/write_parquet.html}).
#'   Can be equal to "snappy" (by default), "gzip", "brotly", "lz4", "zstd" or "none".
#'
#' @return A parquet file
#'
#' @importFrom readr read_delim
#' @importFrom curl curl_download
#' @importFrom arrow write_parquet
#' @importFrom utils unzip
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # Conversion from a local csv file :
#'
#' csv_to_parquet(
#'   path_to_csv = "Data/ac1.csv",
#'   path_to_parquet = "Data",
#' )
#'
#' # Conversion from a URL and a csv file :
#'
#' csv_to_parquet(
#'   url_to_csv = "https://stats.govt.nz/assets/Uploads/Research-and-development-survey/Research-and-development-survey-2021/Download-data/research-and-development-survey-2021-csv.csv",
#'   path_to_parquet = "Data",
#' )
#'
#' # Conversion from a URL and a zipped file :
#'
#' csv_to_parquet(
#'   url_to_csv = "https://www.insee.fr/fr/statistiques/fichier/3568617/equip-tour-transp-infra-2021.zip",
#'   csv_as_a_zip = TRUE,
#'   filename_in_zip = "equip-tour-transp-infra-2021.csv",
#'   path_to_parquet = "Data",
#' )
#' }


csv_to_parquet <- function(
    path_to_csv,
    url_to_csv,
    csv_as_a_zip = FALSE,
    filename_in_zip,
    path_to_parquet,
    compression_type = "snappy"
    ) {


  # Check if at least one of the two arguments path_to_csv or url_to_csv is set
  if (missing(path_to_csv) & missing(url_to_csv)) {
    stop("Be careful, you have to fill in either the path_to_csv or url_to_csv argument")
  }

  # Check if filename_in_zip is filled in when csv_as_a_zip is TRUE
  if (csv_as_a_zip==TRUE & missing(filename_in_zip)) {
    stop("Be careful, if the csv file is included in a zip then you must indicate the name of the csv file to convert")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    stop("Be careful, the argument path_to_parquet must be filled in")
  }

  if (missing(path_to_csv)==FALSE) {

    csv_output <- read_delim(path_to_csv,
                             lazy = TRUE)

    parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_csv)),".parquet")

  } else if (missing(url_to_csv)==FALSE) {

    if (csv_as_a_zip==FALSE) {

      csv_output <- read_delim(url_to_csv,
                               lazy = TRUE)

      parquetname <- paste0(gsub("\\..*","",sub(".*/","", url_to_csv)),".parquet")

    } else if (csv_as_a_zip==TRUE) {

      zip_file <- curl_download(url_to_csv,tempfile())
      csv_file <- unzip(zipfile=zip_file,exdir=tempfile())
      names(csv_file) <- sub('.*/', '', csv_file)

      csv_output <- read_delim(csv_file[filename_in_zip],
                               lazy = TRUE)

      parquetname <- paste0(gsub("\\..*","",filename_in_zip),".parquet")
    }

  }

  parquetfile <- write_parquet(csv_output,
                               sink = file.path(path_to_parquet,
                                                parquetname),
                               compression = compression_type
                               )

  message(paste0("The csv file is available in parquet format under ",path_to_parquet))

  return(invisible(parquetfile))

}
