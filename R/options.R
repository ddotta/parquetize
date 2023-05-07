#' @noRd
check_arguments <- function(...) {
  check_function <- getOption("parquetize_check_arguments")

  if (is.null(check_function)) return()

  check_function(...)
}
