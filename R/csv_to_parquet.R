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
#' @param filename_in_zip name of the csv file in the zip (useful if several csv are included in the zip)
#' @param path_to_parquet string that indicaters the path to the parquet file
#'
#' @return A parquet file
#'
#' @importFrom readr read_delim
#' @importFrom curl curl_download
#' @importFrom arrow write_parquet
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # Conversion from a local csv file :
#'
#' csv_to_parquet(
#'   path_to_csv = "Downloads/ac1.csv",
#'   path_to_parquet = "Downloads/ac1.parquet",
#' )
#'
#' # Conversion frome a URL and a csv file :
#'
#' csv_to_parquet(
#'   url_to_csv = "https://stats.govt.nz/assets/Uploads/Research-and-development-survey/Research-and-development-survey-2021/Download-data/research-and-development-survey-2021-csv.csv",
#'   path_to_parquet = "Downloads/research-and-development-survey-2021.parquet",
#' )
#'
#' # Conversion from a URL and a zipped file :
#'
#' csv_to_parquet(
#'   url_to_csv = "https://www.insee.fr/fr/statistiques/fichier/3568617/equip-tour-transp-infra-2021.zip",
#'   csv_as_a_zip = TRUE,
#'   filename_in_zip = "equip-tour-transp-infra-2021.csv",
#'   path_to_parquet = "Downloads/equip-tour-transp-infra-2021.parquet",
#' )
#' }


csv_to_parquet <- function(
    path_to_csv,
    url_to_csv,
    csv_as_a_zip = FALSE,
    filename_in_zip,
    path_to_parquet
    ) {


  # Check if at least one of the two arguments path_to_csv or url_to_csv is set
  if (missing(path_to_csv) & missing(url_to_csv)) {
    print("Be careful, you have to fill in either the path_to_csv or url_to_csv argument")
  }

  if (missing(path_to_csv)==FALSE) {

    csv_output <- read_delim(path_to_csv,
                             lazy = TRUE)

  } else if (missing(url_to_csv)==FALSE) {

    if (csv_as_a_zip==FALSE) {

      csv_output <- read_delim(url_to_csv,
                               lazy = TRUE)

    } else if (csv_as_a_zip==TRUE) {

      zip_file <- curl_download(url_to_csv,tempfile())
      csv_file <- unzip(zipfile=zip_file,exdir=tempfile())
      names(csv_file) <- sub('.*/', '', csv_file)

      csv_output <- read_delim(csv_file[filename_in_zip],
                               lazy = TRUE)
    }

  }

  parquetfile <- write_parquet(csv_output,
                               sink = path_to_parquet)

  return(invisible(parquetfile))

  message(paste0("The csv file is available in parquet format under ",path_to_parquet))

}
