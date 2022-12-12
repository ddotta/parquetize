#' Convert a csv file to parquet format
#'
#' This function allows to convert a csv file to parquet format. \cr
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
#' Two conversions possibilities are offered :
#'
#'\itemize{
#'
#' \item{Convert to a single parquet file. Argument `path_to_parquet` must then be used;}
#' \item{Convert to a partitioned parquet file. Additionnal arguments `partition` and `partitioning` must then be used;}
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
#' @param partition string ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' @param encoding string that indicates the character encoding for the input file.
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#'
#' @note Be careful, if the zip size exceeds 4 GB, the function may truncate
#' the data (because unzip() won't work reliably in this case -
#' see \href{https://rdrr.io/r/utils/unzip.html}{here}).
#' In this case, it's advised to unzip your csv file by hand
#' (for example with \href{https://www.7-zip.org/}{7-Zip})
#' then use the function with the argument `path_to_csv`.
#'
#' @return A parquet file, invisibly
#'
#' @importFrom readr read_delim locale
#' @importFrom curl curl_download
#' @importFrom arrow write_parquet
#' @importFrom utils unzip
#' @importFrom cli cli_alert_danger cli_progress_message cli_alert_success
#' @export
#'
#' @examples
#'
#' # Conversion from a local csv file to a single parquet file :
#'
#' csv_to_parquet(
#'   path_to_csv = parquetize_example("region_2022.csv"),
#'   path_to_parquet = tempdir()
#' )
#'
#' # Conversion from a local csv file  to a partitioned parquet file  :
#'
#' csv_to_parquet(
#'   path_to_csv = parquetize_example("region_2022.csv"),
#'   path_to_parquet = tempdir(),
#'   partition = "yes",
#'   partitioning =  c("REG")
#' )
#'
#' # Conversion from a URL and a csv file with "gzip" compression :
#'
#' csv_to_parquet(
#'   url_to_csv = "https://stats.govt.nz/assets/Uploads/Research-and-development-survey/Research-and-development-survey-2021/Download-data/research-and-development-survey-2021-csv.csv",
#'   path_to_parquet = tempdir(),
#'   compression = "gzip",
#'   compression_level = 5
#' )
#'
#' # Conversion from a URL and a zipped file :
#'
#' csv_to_parquet(
#'   url_to_csv = "https://www.insee.fr/fr/statistiques/fichier/5057840/cog_ensemble_2021_csv.zip",
#'   csv_as_a_zip = TRUE,
#'   filename_in_zip = "commune2021.csv",
#'   path_to_parquet = tempdir()
#' )

csv_to_parquet <- function(
    path_to_csv,
    url_to_csv,
    csv_as_a_zip = FALSE,
    filename_in_zip,
    path_to_parquet,
    compression = "snappy",
    compression_level = NULL,
    partition = "no",
    encoding = "UTF-8",
    ...
    ) {


  # Check if at least one of the two arguments path_to_csv or url_to_csv is set
  if (missing(path_to_csv) & missing(url_to_csv)) {
    cli_alert_danger("Be careful, you have to fill in either the path_to_csv or url_to_csv argument")
  }

  # Check if filename_in_zip is filled in when csv_as_a_zip is TRUE
  if (csv_as_a_zip==TRUE & missing(filename_in_zip)) {
    cli_alert_danger("Be careful, if the csv file is included in a zip then you must indicate the name of the csv file to convert")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_alert_danger("Be careful, the argument path_to_parquet must be filled in")
  }

  # Check if path_to_parquet exists
  if (dir.exists(path_to_parquet)==FALSE) {
    dir.create(path_to_parquet, recursive = TRUE)
  }

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  if (missing(path_to_csv)==FALSE) {

    csv_output <- read_delim(file = path_to_csv,
                             locale = locale(encoding = encoding),
                             lazy = TRUE,
                             show_col_types = FALSE)

    Sys.sleep(0.01)
    cli_progress_message("Writing data...")

    parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_csv)),".parquet")

  } else if (missing(url_to_csv)==FALSE) {

    if (csv_as_a_zip==FALSE) {

      csv_output <- read_delim(file = url_to_csv,
                               locale = locale(encoding = encoding),
                               lazy = TRUE,
                               show_col_types = FALSE)

      parquetname <- paste0(gsub("\\..*","",sub(".*/","", url_to_csv)),".parquet")

    } else if (csv_as_a_zip==TRUE) {

      zip_file <- curl_download(url_to_csv,tempfile())
      csv_file <- unzip(zipfile=zip_file,exdir=tempfile())
      names(csv_file) <- sub('.*/', '', csv_file)

      csv_output <- read_delim(file = csv_file[[filename_in_zip]],
                               locale = locale(encoding = encoding),
                               lazy = TRUE,
                               show_col_types = FALSE)

      parquetname <- paste0(gsub("\\..*","",filename_in_zip),".parquet")
    }

  }

  if (partition %in% c("no")) {

    parquetfile <- write_parquet(csv_output,
                                 sink = file.path(path_to_parquet,
                                                  parquetname),
                                 ...
    )

  } else if (partition %in% c("yes")) {

    parquetfile <- write_dataset(csv_output,
                                 path = path_to_parquet,
                                 ...)

  }

  cli_alert_success("\nThe csv file is available in parquet format under {path_to_parquet}")

  return(invisible(parquetfile))

}
