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
#' # Donnees (fictives) :
#'
#' mes_donnees <- data.frame(
#'  REG = c("84","76","11","84"),
#'  DEP = c("01","09","92","26")
#' )
#'
#' extrait_flores_ent_19 <- ajoute_zonages_filiere(
#'  base = mes_donnees)


csv_to_parquet <- function(
    path_to_csv,
    url_to_csv,
    csv_as_a_zip = FALSE,
    path_to_parquet
    ) {


  # Check if at least one of the two arguments path_to_csv or url_to_csv is set
  if (missing(path_to_csv) & missing(url_to_csv)) {
    print("Be careful, you have to fill in either the path_to_csv or url_to_csv argument")
  }

  if (missing(path_to_csv)==FALSE) {

    csv_output <- read_delim(path_to_csv)

  } else if (missing(url_to_csv)==FALSE) {

    if (csv_as_a_zip==FALSE) {

      csv_output <- read_delim(url_to_csv)

    } else if (csv_as_a_zip==TRUE) {

      zipfile <- curl_download(url_to_csv,tempfile())
      csvfile <- unzip(zipfile)

      csv_output <- read_delim(csvfile)
    }

  }

  parquetfile <- write_parquet(csv_output,
                               sink = path_to_parquet)

  return(parquetfile)

}
