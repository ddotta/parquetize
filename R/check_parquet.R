#' Check a parquet file or dataset
#'
#' @description This function check if a file/dataset is a valid parquet format.
#'   It will print the number of lines/columns and return a tibble on columns
#'   information.
#'
#' @details This function will :
#'
#' * open the parquet dataset/file to check if it's valid
#' * print the number of lines
#' * print the number of columns
#' * return a tibble with 3 columns :
#'
#'   * the column name (string)
#'   * the arrow type (string)
#'   * if the column is nullable or not (boolean)
#'
#' You can find a list of arrow type in the documentation :
#' https://arrow.apache.org/docs/r/articles/data_types.html
#'
#' @param path path to the file or dataset
#'
#' @return a tibble with information on parquet dataset/file's columns with
#'   three columns : field name, arrow type and nullable
#'
#' @importFrom arrow open_dataset read_parquet
#' @export
#'
#' @examples
#'
#' # check a parquet file
#' check_parquet(parquetize_example("iris.parquet"))
#'
#' #' # check a parquet dataset
#' #' check_parquet(parquetize_example("iris"))
check_parquet <- function(path) {
  cli_alert_info("checking: {path}")

  ds <- arrow::open_dataset(path, unify_schemas = TRUE)
  cli_alert_success("loading dataset:   ok")

  cli_alert_success("number of lines:   {nrow(ds)}")
  cli_alert_success("number of columns: {length(names(ds))}")

  get_col_types(ds)
}

get_col_types <- function(ds) {
  fields <- ds$schema$fields

  tibble(
    name = unlist(lapply(fields, function(x) { x$name })),
    type = unlist(lapply(fields, function(x) { x$type$name })),
    nullable = unlist(lapply(fields, function(x) { x$nullable }))
  )
}
