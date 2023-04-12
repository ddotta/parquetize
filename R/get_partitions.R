#' @name get_partitions
#'
#' @title get unique values from table's column
#'
#' @description This function allows you to extract unique values from a table's column to use as partitions.\cr
#'
#' Internally, this function does "SELECT DISTINCT(`mycolumn`) FROM `mytable`;"
#'
#' @param conn A `DBIConnection` object, as return by `DBI::dbConnect`
#' @param table a DB table name
#' @param column a column name for the table passed in param
#'
#' @return a vector with unique values for the column of the table
#' @export
#' @importFrom glue glue_sql
#'
#' @examples
#' dbi_connection <- DBI::dbConnect(RSQLite::SQLite(),
#'   system.file("extdata","iris.sqlite",package = "parquetize"))
#'
#' get_partitions(dbi_connection, "iris", "Species")
get_partitions <- function(conn, table, column) {
  if (missing(conn)) {
    cli_abort("Be careful, the argument conn must be filled in", class = "parquetize_missing_argument")
  }
  if (missing(table)) {
    cli_abort("Be careful, the argument table must be filled in", class = "parquetize_missing_argument")
  }
  if (missing(column)) {
    cli_abort("Be careful, the argument column must be filled in", class = "parquetize_missing_argument")
  }

  DBI::dbGetQuery(conn, glue::glue("SELECT distinct({`column`}) FROM '{`table`}'", .con = conn))[,1]
}
