#' @name csv_to_parquet
#' @title Convert a csv file to parquet format
#'
#' @description This function allows to convert a csv file to parquet format. \cr
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
#' @param path_to_csv string that indicates the path or url to the csv file
#' @param url_to_csv DEPRECATED use path_to_csv instead
#' @param csv_as_a_zip DEPRECATED
#' @param filename_in_zip name of the csv file in the zip. Required if several csv are included in the zip.
#' @param path_to_parquet string that indicates the path to the directory where the parquet file will be stored
#' @param columns character vector of columns to select from the input file (by default, all columns are selected).
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
#' @importFrom cli cli_alert_danger cli_progress_message cli_alert_success cli_alert_info
#' @importFrom tidyselect all_of everything
#' @importFrom lifecycle deprecate_warn deprecated
#' @export
#'
#' @examples
#'
#'
#' # Conversion from a local csv file to a single parquet file :
#'
#' csv_to_parquet(
#'   path_to_csv = parquetize_example("region_2022.csv"),
#'   path_to_parquet = tempdir()
#' )
#'
#' # Conversion from a local csv file to a single parquet file and select only
#' # few columns :
#'
#' csv_to_parquet(
#'   path_to_csv = parquetize_example("region_2022.csv"),
#'   path_to_parquet = tempdir(),
#'   columns = c("REG","LIBELLE")
#' )
#'
#' # Conversion from a local csv file to a partitioned parquet file  :
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
#'   path_to_csv =
#'   "https://github.com/sidsriv/Introduction-to-Data-Science-in-python/raw/master/census.csv",
#'   path_to_parquet = tempdir(),
#'   compression = "gzip",
#'   compression_level = 5
#' )
#'
#' # Conversion from a URL and a zipped file :
#'
#' csv_to_parquet(
#'   path_to_csv = "https://www.nomisweb.co.uk/output/census/2021/census2021-ts007.zip",
#'   filename_in_zip = "census2021-ts007-ctry.csv",
#'   path_to_parquet = tempdir()
#' )

csv_to_parquet <- function(
    path_to_csv,
    url_to_csv = deprecated(),
    csv_as_a_zip = deprecated(),
    filename_in_zip,
    path_to_parquet,
    columns = "all",
    compression = "snappy",
    compression_level = NULL,
    partition = "no",
    encoding = "UTF-8",
    ...
) {
  if (!missing(url_to_csv)) {
    lifecycle::deprecate_warn(
      when = "0.5.5",
      what = "csv_to_parquet(url_to_csv)",
      details = "This argument is replaced by path_to_csv."
    )
  }

  if (!missing(csv_as_a_zip)) {
    lifecycle::deprecate_warn(
      when = "0.5.5",
      what = "csv_to_parquet(csv_as_a_zip)",
      details = "This argument is no longer needed, parquetize detect zip file by extension."
    )
  }

  # Check if at least one of the two arguments path_to_csv or url_to_csv is set
  if (missing(path_to_csv) & missing(url_to_csv)) {
    cli_alert_danger("Be careful, you have to fill in either the path_to_csv or url_to_csv argument")
    stop("")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_alert_danger("Be careful, the argument path_to_parquet must be filled in")
    stop("")
  }

  dir.create(path_to_parquet, recursive = TRUE, showWarnings = FALSE)

  # Check if columns argument is a character vector
  if (isFALSE(is.vector(columns) & is.character(columns))) {
    cli_alert_danger("Be careful, the argument columns must be a character vector")
    cli_alert_info('You can use `all` or `c("col1", "col2"))`')
    stop("")
  }

  if (missing(path_to_csv)) {
    path_to_csv <- url_to_csv
  }

  input_file <- download_extract(path_to_csv, filename_in_zip)

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  csv_output <- read_delim(
    file = input_file,
    locale = locale(encoding = encoding),
    lazy = TRUE,
    show_col_types = FALSE,
    col_select = if (identical(columns,"all")) everything() else all_of(columns)
  )


  Sys.sleep(0.01)
  cli_progress_message("Writing data...")

  parquetname <- get_parquet_file_name(input_file)
  parquetfile <- write_data_in_parquet(csv_output, path_to_parquet, parquetname, partition, ...)

  cli_alert_success("\nThe csv file is available in parquet format under {path_to_parquet}")

  return(invisible(parquetfile))
}
