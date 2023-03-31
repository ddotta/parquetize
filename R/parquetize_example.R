#' @name parquetize_example
#'
#' @title Get path to parquetize example
#'
#' @description parquetize comes bundled with a number of sample files in its `inst/extdata`
#' directory. This function make them easy to access
#'
#' @param file Name of file. If `NULL`, the example files will be listed.
#
#' @return A character string
#'
#' @export
#' @examples
#' parquetize_example()
#' parquetize_example("region_2022.csv")
#' parquetize_example("iris_dataset")

parquetize_example <- function(file = NULL) {
  extension <- tools::file_ext(file)

  # To show all example files contained in parquetize
  if (is.null(file)) {
    dir(system.file("extdata", package = "parquetize"))
  # To get the path to a file with an extension
  } else if (extension != "") {
    path_to_file <- system.file("extdata", file, package = "parquetize")
    if (path_to_file == "") {
      cli_alert_danger("Be careful, {file} doesn't exist in parquetize")
      stop("")
    } else {
      system.file("extdata", file, package = "parquetize", mustWork = TRUE)
    }
  # To get the path to a dataset without an extension
  } else if (extension == "") {
    path_to_file <- system.file(file.path("extdata",file), package = "parquetize")
    if (path_to_file == "") {
      cli_alert_danger("Be careful, {file} doesn't exist in parquetize")
      stop("")
    } else {
      system.file(file.path("extdata",file), package = "parquetize", mustWork = TRUE)
    }
  }
}
