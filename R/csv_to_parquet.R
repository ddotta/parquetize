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
#' @param filename_in_zip name of the csv file in the zip. Required if several csv are included in the zip.
#' @param url_to_csv DEPRECATED use path_to_file instead
#' @param csv_as_a_zip DEPRECATED
#' @inheritParams table_to_parquet
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#'
#' @note Be careful, if the zip size exceeds 4 GB, the function may truncate
#' the data (because unzip() won't work reliably in this case -
#' see \href{https://rdrr.io/r/utils/unzip.html}{here}).
#' In this case, it's advised to unzip your csv file by hand
#' (for example with \href{https://www.7-zip.org/}{7-Zip})
#' then use the function with the argument `path_to_file`.
#'
#' @return A parquet file, invisibly
#'
#' @export
#'
#' @examples
#'
#' # Conversion from a local csv file to a single parquet file :
#'
#' csv_to_parquet(
#'   path_to_file = parquetize_example("region_2022.csv"),
#'   path_to_parquet = tempfile(fileext=".parquet")
#' )
#'
#' # Conversion from a local csv file to a single parquet file and select only
#' # few columns :
#'
#' csv_to_parquet(
#'   path_to_file = parquetize_example("region_2022.csv"),
#'   path_to_parquet = tempfile(fileext = ".parquet"),
#'   columns = c("REG","LIBELLE")
#' )
#'
#' # Conversion from a local csv file to a partitioned parquet file  :
#'
#' csv_to_parquet(
#'   path_to_file = parquetize_example("region_2022.csv"),
#'   path_to_parquet = tempfile(fileext = ".parquet"),
#'   partition = "yes",
#'   partitioning =  c("REG")
#' )
#'
#' # Conversion from a URL and a zipped file :
#'
#' csv_to_parquet(
#'   path_to_file = "https://www.nomisweb.co.uk/output/census/2021/census2021-ts007.zip",
#'   filename_in_zip = "census2021-ts007-ctry.csv",
#'   path_to_parquet = tempfile(fileext = ".parquet")
#' )
#'
#' \dontrun{
#' # Conversion from a URL and a csv file with "gzip" compression :
#'
#' csv_to_parquet(
#'   path_to_file =
#'   "https://github.com/sidsriv/Introduction-to-Data-Science-in-python/raw/master/census.csv",
#'   path_to_parquet = tempfile(fileext = ".parquet"),
#'   compression = "gzip",
#'   compression_level = 5
#' )
#' }
csv_to_parquet <- function(
    path_to_file,
    url_to_csv = lifecycle::deprecated(),
    csv_as_a_zip = lifecycle::deprecated(),
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
      details = "This argument is replaced by path_to_file."
    )
  }

  if (!missing(csv_as_a_zip)) {
    lifecycle::deprecate_warn(
      when = "0.5.5",
      what = "csv_to_parquet(csv_as_a_zip)",
      details = "This argument is no longer needed, parquetize detect zip file by extension."
    )
  }

  # Check if at least one of the two arguments path_to_file or url_to_csv is set
  if (missing(path_to_file) & missing(url_to_csv)) {
    cli_abort("Be careful, you have to fill the path_to_file argument", class = "parquetize_missing_argument")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_abort("Be careful, the argument path_to_parquet must be filled in", class = "parquetize_missing_argument")
  }

  # Check if columns argument is a character vector
  if (isFALSE(is.vector(columns) & is.character(columns))) {
    cli_abort(c("Be careful, the argument columns must be a character vector",
              'You can use `all` or `c("col1", "col2"))`'),
              class = "parquetize_bad_argument")
  }

  if (missing(path_to_file)) {
    path_to_file <- url_to_csv
  }

  input_file <- download_extract(path_to_file, filename_in_zip)

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  csv_output <- read_delim(
    file = input_file,
    locale = locale(encoding = encoding),
    lazy = TRUE,
    show_col_types = FALSE,
    col_select = if (identical(columns,"all")) everything() else all_of(columns)
  )

  dataset <- write_parquet_at_once(
    csv_output,
    path_to_parquet,
    partition,
    compression,
    compression_level,
    ...)

  return(invisible(dataset))
}
