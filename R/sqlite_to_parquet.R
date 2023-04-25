#' @name sqlite_to_parquet
#'
#' @title Convert a sqlite file to parquet format
#'
#' @description This function allows to convert a table from a sqlite file to parquet format. \cr
#' The following extensions are supported :
#' "db","sdb","sqlite","db3","s3db","sqlite3","sl3","db2","s2db","sqlite2","sl2". \cr
#'
#' Two conversions possibilities are offered :
#'
#'\itemize{
#'
#' \item{Convert to a single parquet file. Argument `path_to_parquet` must then be used;}
#' \item{Convert to a partitioned parquet file. Additionnal arguments `partition` and `partitioning` must then be used;}
#'
#' }
#'
#' @param path_to_sqlite string that indicates the path to the sqlite file
#' @param table_in_sqlite string that indicates the name of the table to convert in the sqlite file
#' @param path_to_parquet string that indicates the path to the directory where the parquet file will be stored
#' @param partition string ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @export
#'
#' @examples
#'
#' # Conversion from a local sqlite file to a single parquet file :
#'
#' sqlite_to_parquet(
#'   path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
#'   table_in_sqlite = "iris",
#'   path_to_parquet = tempfile(fileext = ".parquet")
#' )
#'
#' # Conversion from a local sqlite file to a partitioned parquet file  :
#'
#' sqlite_to_parquet(
#'   path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
#'   table_in_sqlite = "iris",
#'   path_to_parquet = tempfile(),
#'   partition = "yes",
#'   partitioning =  c("Species")
#' )

sqlite_to_parquet <- function(
    path_to_sqlite,
    table_in_sqlite,
    path_to_parquet,
    partition = "no",
    ...
) {

  # Check if path_to_sqlite is missing
  if (missing(path_to_sqlite)) {
    cli_abort("Be careful, the argument path_to_sqlite must be filled in", class = "parquetize_missing_argument")
  }

  # Check if extension used in path_to_sqlite is correct
  if (!(sub(".*\\.", "", path_to_sqlite) %in% c("db","sdb","sqlite","db3","s3db","sqlite3","sl3","db2","s2db","sqlite2","sl2"))) {
    cli_abort("Be careful, the extension used in path_to_sqlite is not correct", class = "parquetize_bad_format")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_abort("Be careful, the argument path_to_parquet must be filled in", class = "parquetize_missing_argument")
  }

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  con_sqlite <- DBI::dbConnect(RSQLite::SQLite(), path_to_sqlite)

  # Check if table_in_sqlite exists in sqlite file
  list_table <- DBI::dbListTables(con_sqlite)
  if (!(table_in_sqlite %in% list_table)==TRUE) {
    cli_abort("Be careful, the table filled in the table_in_sqlite argument {table_in_sqlite} does not exist in your sqlite file",
              class = "parquetize_missing_table")
  }

  sqlite_output <- DBI::dbReadTable(con_sqlite, table_in_sqlite)

  DBI::dbDisconnect(con_sqlite, shutdown=TRUE)

  Sys.sleep(0.01)
  cli_progress_message("Writing data...")

  dataset <- write_parquet_at_once(sqlite_output, path_to_parquet, partition, ...)

  return(invisible(dataset))

}
