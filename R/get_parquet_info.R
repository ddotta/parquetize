#' @name get_parquet_info
#'
#' @title Get various info on parquet files
#'
#' @description One very important parquet metadata is the row group size.\cr
#'
#' If it's value is low (below 10 000), you should rebuild your parquet files.\cr
#'
#' Normal value is between 30 000 and 1 000 000
#'
#' @param path parquet file path or directory. If directory is given,
#'   `get_parquet_info` will be applied on all parquet files found in
#'   subdirectories
#'
#' @return a tibble with 5 columns :
#' * path, file path
#' * num_rows, number of rows
#' * num_row_groups, number of group row
#' * num_columns,
#' * row_group_size, mean row group size
#'
#' If one column contain `NA`, parquet file may be malformed.
#'
#' @export
#'
#' @examples
#' get_parquet_info(system.file("extdata", "iris.parquet", package = "parquetize"))
#'
#' get_parquet_info(system.file("extdata", "iris_dataset", package = "parquetize"))
get_parquet_info <- function(path) {
  if (dir.exists(path)) {
    files <- list.files(path, recursive = TRUE, pattern = "*.parquet$", full.names = T)
  } else if (file.exists(path)) {
    files <- path
  } else {
    stop("path must be a file or a directory")
  }

  tibble::tibble(
    path = files,
    num_rows = sapply(files, get_parquet_attribute, attribute = "num_rows"),
    num_row_groups = sapply(files, get_parquet_attribute, attribute = "num_row_groups"),
    num_columns = sapply(files, get_parquet_attribute, attribute = "num_columns")
  ) %>%
    dplyr::mutate(
      mean_row_group_size = .data$num_rows / .data$num_row_groups
    )
}

#' @name get_parquet_attribute
#'
#' @title Utility to get attributes from a parquet file
#'
#' @param path parquet file path or directory.
#' @param attribute name of searched attribute
#'
#' @noRd
get_parquet_attribute <- function(path, attribute) {
  tryCatch({
    reader <- arrow::ParquetFileReader$create(path)
    reader[[attribute]]
  },
  error = function(e) { return(NA_real_) }
  )
}
