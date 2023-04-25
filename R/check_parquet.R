#' @name check_parquet
#'
#' @title Check if parquet file or dataset is readable and return basic informations
#'
#' @description This function checks if a file/dataset is a valid parquet format.
#'   It will print the number of lines/columns and return a tibble on columns
#'   information.
#'
#' @details This function will :
#'
#' * open the parquet dataset/file to check if it's valid
#' * print the number of lines
#' * print the number of columns
#' * return a tibble with 2 columns :
#'
#'   * the column name (string)
#'   * the arrow type (string)
#'
#' You can find a list of arrow type in the documentation
#' \href{https://arrow.apache.org/docs/r/articles/data_types.html}{on this page}.
#'
#' @param path path to the file or dataset
#'
#' @return a tibble with information on parquet dataset/file's columns with
#'   three columns : field name, arrow type and nullable
#'
#' @export
#'
#' @examples
#'
#' # check a parquet file
#' check_parquet(parquetize_example("iris.parquet"))
#'
#' # check a parquet dataset
#' check_parquet(parquetize_example("iris_dataset"))
check_parquet <- function(path) {

  if (isFALSE(file.exists(path))) {
    cli_abort("Be careful, {path} doesn't exist", class = "no_such_file")
  }

  cli_alert_info("checking: {path}")

  ds <- arrow::open_dataset(path, unify_schemas = TRUE)
  cli_alert_success("loading dataset:   ok")

  cli_alert_success("number of lines:   {nrow(ds)}")
  cli_alert_success("number of columns: {length(names(ds))}")

  get_col_types(ds)
}
