#' Check if parquet dataset/file is readable and has the good number of rows
#'
#' @param path to the parquet file or dataset
#' @param with_lines number of lines the file/dataset should have
#' @param with_partitions NULL or a vector with the partition names the dataset should have
#' @param with_columns NULL or a column's name vector the dataset/file should have
#' @param with_files NULL or number of files a dataset should have
#'
#' @return the dataset handle
#' @export
#'
#' @keywords internal
expect_parquet <- function(
    path,
    with_lines,
    with_partitions = NULL,
    with_columns = NULL,
    with_files = NULL) {

  check_arrow_installed()

  dataset <- testthat::expect_no_error(arrow::open_dataset(path))
  testthat::expect_equal(nrow(dataset), with_lines)

  if (!is.null(with_partitions)) {
    tryCatch(
      testthat::expect_setequal(dir(path), with_partitions),
      error = function(cond) { cli::cli_abort("{with_partitions} different from {dir(path)}", class = "partquetize_test_with_partitions")}
    )
  }

  if (!is.null(with_columns)) {
    tryCatch(
      testthat::expect_setequal(names(dataset), with_columns),
      error = function(cond) { cli::cli_abort("{with_columns} different from {names(dataset)}", class = "partquetize_test_with_columns") }
    )
  }

  if (!is.null(with_files)) {
    files_number <- length(dataset$files)

    tryCatch(
      testthat::expect_equal(files_number, with_files),
      error = function(cond) { cli::cli_abort("we should have {with_files} files. We have {files_number}", class = "partquetize_test_with_files") }
    )
  }
  return(dataset)
}

#' Check if missing argument error is raised
#'
#' @param object the object to check
#' @param message a regexp with the message we must find
#'
#' @return same as expect_error
#' @export
#'
#' @keywords internal
expect_missing_argument <- function(object, regexp) {
  testthat::expect_error(
    object,
    class = "parquetize_missing_argument",
    regexp = regexp
  )
}
