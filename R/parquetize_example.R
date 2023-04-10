#' @name parquetize_example
#'
#' @title Get path to parquetize example
#'
#' @description parquetize comes bundled with a number of sample files in its `inst/extdata`
#' directory. This function make them easy to access
#'
#' @param file Name of file or directory. If `NULL`, the example files will be listed.
#
#' @return A character string
#'
#' @export
#' @examples
#' parquetize_example()
#' parquetize_example("region_2022.csv")
#' parquetize_example("iris_dataset")

parquetize_example <- function(file = NULL) {
  # To show all example files contained in parquetize
  if (is.null(file)) {
    return(dir(system.file("extdata", package = "parquetize")))
  }

  #To get the path to a file or a   directory
  tryCatch(
    system.file("extdata", file, package = "parquetize", mustWork = TRUE),
    error = function(cond) cli_abort("Be careful, {file} doesn't exist in parquetize", class = "no_such_file")
  )
}
