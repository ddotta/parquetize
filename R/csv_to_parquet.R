#' Convert a csv table to parquet format
#'
#' This function allows to convert a csv table to parquet format. \cr
#'
#' Several conversion possibilities are offered :
#'
#'\itemize{
#'
#' \item{From a locally stored file. Argument `path_to_csv` must then be used;}
#' \item{From a URL. Argument `url_to_csv` must then be used.}
#'
#' }
#'
#' @param path_to_csv string that indicates the path to the csv file
#' @param url_to_csv string that indicates the URL of the csv file
#' @param csv_as_a_zip boolean that indicates if the csv is stored in a zip
#' @param filename_in_zip name of the csv file in the zip (useful if several csv are included in the zip). Required if `csv_as_a_zip` is TRUE.
#' @param path_to_parquet string that indicates the path to the directory where the parquet file will be stored
#' @param compression compression algorithm. Default "snappy".
#' @param compression_level compression level. Meaning depends on compression algorithm.
#' @param encoding string that indicates the character encoding for the input file.
#' @param progressbar string () ("yes" or "no" - by default) that indicates whether you want a progress bar to display
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @importFrom readr read_delim locale
#' @importFrom curl curl_download
#' @importFrom arrow write_parquet
#' @importFrom utils unzip
#' @export
#'
#' @examples
#'
#' # Conversion from a local csv file :
#'
#' csv_to_parquet(
#'   path_to_csv = parquetize_example("region_2022.csv"),
#'   path_to_parquet = tempdir(),
#'   progressbar = "no"
#' )
#'
#' # Conversion from a URL and a csv file with "gzip" compression :
#'
#' csv_to_parquet(
#'   url_to_csv = "https://stats.govt.nz/assets/Uploads/Research-and-development-survey/Research-and-development-survey-2021/Download-data/research-and-development-survey-2021-csv.csv",
#'   path_to_parquet = tempdir(),
#'   compression = "gzip",
#'   compression_level = 5,
#'   progressbar = "no"
#' )
#'
#' # Conversion from a URL and a zipped file :
#'
#' csv_to_parquet(
#'   url_to_csv = "https://www.insee.fr/fr/statistiques/fichier/5057840/cog_ensemble_2021_csv.zip",
#'   csv_as_a_zip = TRUE,
#'   filename_in_zip = "commune2021.csv",
#'   path_to_parquet = tempdir(),
#'   progressbar = "no"
#' )

csv_to_parquet <- function(
    path_to_csv,
    url_to_csv,
    csv_as_a_zip = FALSE,
    filename_in_zip,
    path_to_parquet,
    compression = "snappy",
    compression_level = NULL,
    encoding = "UTF-8",
    progressbar = "yes",
    ...
    ) {


  if (progressbar %in% c("yes")) {
    # Initialize the progress bar
    conversion_progress <- txtProgressBar(style = 3)
  }

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

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 1)

  if (missing(path_to_csv)==FALSE) {

    csv_output <- read_delim(file = path_to_csv,
                             locale = locale(encoding = encoding),
                             lazy = TRUE,
                             show_col_types = FALSE)

    update_progressbar(pbar = progressbar,
                       name_progressbar = conversion_progress,
                       value = 6)

    parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_csv)),".parquet")

  } else if (missing(url_to_csv)==FALSE) {

    if (csv_as_a_zip==FALSE) {

      csv_output <- read_delim(file = url_to_csv,
                               locale = locale(encoding = encoding),
                               lazy = TRUE,
                               show_col_types = FALSE)

      update_progressbar(pbar = progressbar,
                         name_progressbar = conversion_progress,
                         value = 6)

      parquetname <- paste0(gsub("\\..*","",sub(".*/","", url_to_csv)),".parquet")

    } else if (csv_as_a_zip==TRUE) {

      zip_file <- curl_download(url_to_csv,tempfile())
      csv_file <- unzip(zipfile=zip_file,exdir=tempfile())
      names(csv_file) <- sub('.*/', '', csv_file)

      csv_output <- read_delim(file = csv_file[[filename_in_zip]],
                               locale = locale(encoding = encoding),
                               lazy = TRUE,
                               show_col_types = FALSE)

      update_progressbar(pbar = progressbar,
                         name_progressbar = conversion_progress,
                         value = 6)

      parquetname <- paste0(gsub("\\..*","",filename_in_zip),".parquet")
    }

  }

  parquetfile <- write_parquet(csv_output,
                               sink = file.path(path_to_parquet,
                                                parquetname),
                               ...
                               )

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 10)

  message(paste0("\nThe csv file is available in parquet format under ",path_to_parquet))

  return(invisible(parquetfile))

}
