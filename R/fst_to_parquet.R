#' @name fst_to_parquet
#'
#' @title Convert a fst file to parquet format
#'
#' @description This function allows to convert a fst file to parquet format. \cr
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
#' @inheritParams table_to_parquet
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @export
#'
#' @examplesIf require("arrow", quietly = TRUE)
#'
#' # Conversion from a local fst file to a single parquet file ::
#'
#' fst_to_parquet(
#'   path_to_file = system.file("extdata","iris.fst",package = "parquetize"),
#'   path_to_parquet = tempfile(fileext = ".parquet")
#' )
#'
#' # Conversion from a local fst file to a partitioned parquet file  ::
#'
#' fst_to_parquet(
#'   path_to_file = system.file("extdata","iris.fst",package = "parquetize"),
#'   path_to_parquet = tempfile(fileext = ".parquet"),
#'   partition = "yes",
#'   partitioning =  c("Species")
#' )

fst_to_parquet <- function(
    path_to_file,
    path_to_parquet,
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

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  fst_output <- fst::read.fst(path = path_to_file)

  dataset <- write_parquet_at_once(
    fst_output,
    path_to_parquet,
    partition,
    compression,
    compression_level,
    ...)

  return(invisible(dataset))

}
