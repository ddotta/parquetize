#' @name json_to_parquet
#'
#' @title Convert a json file to parquet format
#'
#' @description This function allows to convert a \href{https://www.json.org/json-en.html}{json}
#' or \href{https://docs.mulesoft.com/dataweave/latest/dataweave-formats-ndjson}{ndjson} file to parquet format. \cr
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
#' @param format string that indicates if the format is "json" (by default) or "ndjson"
#' @inheritParams table_to_parquet
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @export
#'
#' @examples
#'
#' # Conversion from a local json file to a single parquet file ::
#'
#' json_to_parquet(
#'   path_to_file = system.file("extdata","iris.json",package = "parquetize"),
#'   path_to_parquet = tempfile(fileext = ".parquet")
#' )
#'
#' # Conversion from a local ndjson file to a partitioned parquet file  ::
#'
#' json_to_parquet(
#'   path_to_file = system.file("extdata","iris.ndjson",package = "parquetize"),
#'   path_to_parquet = tempfile(fileext = ".parquet"),
#'   format = "ndjson"
#' )

json_to_parquet <- function(
    path_to_file,
    path_to_parquet,
    format = "json",
    partition = "no",
    compression = "snappy",
    compression_level = NULL,
    ...
) {

  # Check if path_to_file is missing
  if (missing(path_to_file)) {
    cli_abort("Be careful, the argument path_to_file must be filled in", class = "parquetize_missing_argument")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_abort("Be careful, the argument path_to_parquet must be filled in", class = "parquetize_missing_argument")
  }

  # Check if format is equal to "json" or "ndjson"
  if (!(format %in% c("json","ndjson"))) {
    cli_abort("Be careful, the argument format must be equal to 'json' or 'ndjson'", class = "parquetize_bad_format")
  }

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  if (format == "json") {
    json_output <- jsonlite::read_json(path = path_to_file,
                                       simplifyVector = TRUE)
  } else if (format == "ndjson") {
    json_output <- read_json_arrow(file = path_to_file,
                                   as_data_frame = TRUE)
  }

  dataset <- write_parquet_at_once(json_output, path_to_parquet, partition, ...)

  return(invisible(dataset))

}
