#' @noRd
check_arguments <- function(...) {
  check_function <- getOption("parquetize_check_arguments")

  if (is.null(check_function)) return()

  check_function(...)
}

#' @noRd
check_result_dataset <- function(dataset, path_to_parquet) {
  check_function <- getOption("parquetize_check_result")

  if (is.null(check_function)) return()

  check_function(dataset, path_to_parquet)
}
