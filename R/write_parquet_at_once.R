#' @name write_parquet_at_once
#'
#' @title write parquet file or dataset based on partition argument \cr
#'
#' @description Low level function that implements the logic to write a parquet file or a dataset from data
#'
#' @param data the data.frame/tibble to write
#' @inheritParams write_parquet_by_chunk
#' @param partition string ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#'
#' @return a dataset as return by arrow::open_dataset
#' @importFrom arrow open_dataset
#'
#' @export
#'
#' @examples
#'
#' write_parquet_at_once(iris, tempfile())
#'
#' write_parquet_at_once(iris, tempfile(), partition = "yes", partitioning = c("Species"))
#'
write_parquet_at_once <- function(data, path_to_parquet, partition = "no", ...) {
  Sys.sleep(0.01)
  cli_progress_message("Writing data...")

  if (missing(data)) {
    cli_abort("Be careful, data argument is mandatory", class = "parquetize_missing_argument")
  }

  if (missing(path_to_parquet)) {
    cli_abort("Be careful, path_to_parquet argument is mandatory", class = "parquetize_missing_argument")
  }

  if (partition == "no") {
    if (isTRUE(file.info(path_to_parquet)$isdir)) {
      path_to_parquet <- file.path(path_to_parquet, paste0(basename(path_to_parquet), ".parquet"))
      cli_alert_warning("Be careful, path_to_parquet should be a file name, using : {path_to_parquet}")
    }

    write_parquet(data,
                  sink = path_to_parquet,
                  ...)
    parquet_type <- "file"
  } else if (partition == "yes") {
    write_dataset(data,
                  path = path_to_parquet,
                  ...)
    parquet_type <- "dataset"
  }
  Sys.sleep(0.01)
  cli_alert_success("\nData are available in parquet {parquet_type} under {path_to_parquet}")
  invisible(arrow::open_dataset(path_to_parquet))
}
