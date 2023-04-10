#' Check if parquet dataset/file is readable and has the good number of rows
#'
#' @param path to the parquet file or dataset
#' @param with_lines number of lines we should have
#' @param partitions a vector with the partition names we should have
#'
#' @return the dataset handle
#' @export
#'
#' @keywords internal
expect_parquet <- function(path, with_lines, with_partitions = NULL) {
  r <- testthat::expect_no_error(arrow::open_dataset(path))
  testthat::expect_equal(nrow(r), with_lines)
  if (!is.null(with_partitions)) {
    testthat::expect_identical(
      sort(dir(path)),
      sort(with_partitions)
    )
  }
  return(r)
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
