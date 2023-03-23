#' @name rds_to_parquet
#'
#' @title Convert a rds file to parquet format
#'
#' @description This function allows to convert a rds file to parquet format. \cr
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
#' @param path_to_rds string that indicates the path to the rds file
#' @param path_to_parquet string that indicates the path to the directory where the parquet file will be stored
#' @param partition string ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @importFrom arrow write_parquet write_dataset
#' @importFrom cli cli_alert_danger cli_progress_message cli_alert_success
#' @export
#'
#' @examples
#'
#' # Conversion from a local rds file to a single parquet file ::
#'
#' rds_to_parquet(
#'   path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
#'   path_to_parquet = tempdir()
#' )
#'
#' # Conversion from a local rds file to a partitioned parquet file  ::
#'
#' rds_to_parquet(
#'   path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
#'   path_to_parquet = tempdir(),
#'   partition = "yes",
#'   partitioning =  c("Species")
#' )

rds_to_parquet <- function(
    path_to_rds,
    path_to_parquet,
    partition = "no",
    ...
) {

  # Check if path_to_rds is missing
  if (missing(path_to_rds)) {
    cli_alert_danger("Be careful, the argument path_to_rds must be filled in")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_alert_danger("Be careful, the argument path_to_parquet must be filled in")
  }

  dir.create(path_to_parquet, recursive = TRUE, showWarnings = FALSE)

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  rds_output <- readRDS(file = path_to_rds)

  Sys.sleep(0.01)
  cli_progress_message("Writing data...")

  parquetname <- get_parquet_file_name(path_to_rds)
  parquetfile <- write_data_in_parquet(rds_output, path_to_parquet, parquetname, partition, ...)

  cli_alert_success("\nThe rds file is available in parquet format under {path_to_parquet}")

  return(invisible(parquetfile))

}
