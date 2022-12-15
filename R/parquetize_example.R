#' @name parquetize_example
#'
#' @title Get path to parquetize example
#'
#' @description parquetize comes bundled with a number of sample files in its `inst/extdata`
#' directory. This function make them easy to access
#'
#' @param file Name of file. If `NULL`, the example files will be listed.
#' @export
#' @examples
#' parquetize_example()
#' parquetize_example("region_2022.csv")

parquetize_example <- function(file = NULL) {
  if (is.null(file)) {
    dir(system.file("extdata", package = "parquetize"))
  } else {
    system.file("extdata", file, package = "parquetize", mustWork = TRUE)
  }
}
