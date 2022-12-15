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
#' @importFrom DBI dbConnect dbReadTable dbListTables dbDisconnect
#' @importFrom RSQLite SQLite
#' @importFrom arrow write_parquet write_dataset
#' @importFrom cli cli_alert_danger cli_progress_message cli_alert_success
#' @export
#'
#' @examples
#'
#' # Conversion from a local sqlite file to a single parquet file :
#'
#' sqlite_to_parquet(
#'   path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
#'   table_in_sqlite = "iris",
#'   path_to_parquet = tempdir()
#' )
#'
#' # Conversion from a local sqlite file to a partitioned parquet file  :
#'
#' sqlite_to_parquet(
#'   path_to_sqlite = system.file("extdata","iris.sqlite",package = "parquetize"),
#'   table_in_sqlite = "iris",
#'   path_to_parquet = tempdir(),
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
    cli_alert_danger("Be careful, the argument path_to_sqlite must be filled in")
  }

  # Check if extension used in path_to_sqlite is correct
  if (!(sub(".*\\.", "", path_to_sqlite) %in% c("db","sdb","sqlite","db3","s3db","sqlite3","sl3","db2","s2db","sqlite2","sl2"))) {
    cli_alert_danger("Be careful, the extension used in path_to_sqlite is not correct")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_alert_danger("Be careful, the argument path_to_parquet must be filled in")
  }

  # Check if path_to_parquet exists
  if (dir.exists(path_to_parquet)==FALSE) {
    dir.create(path_to_parquet, recursive = TRUE)
  }

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  con_sqlite <- DBI::dbConnect(RSQLite::SQLite(), path_to_sqlite)

  # Check if table_in_sqlite exists in sqlite file
  list_table <- DBI::dbListTables(con_sqlite)
  if (!(table_in_sqlite %in% list_table)==TRUE) {
    cli_alert_danger("Be careful, the table filled in the table_in_sqlite argument does not exist in your sqlite file")
  }

  sqlite_output <- DBI::dbReadTable(con_sqlite, table_in_sqlite)

  DBI::dbDisconnect(con_sqlite, shutdown=TRUE)

  Sys.sleep(0.01)
  cli_progress_message("Writing data...")

  parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_sqlite)),".parquet")

  if (partition %in% c("no")) {

    parquetfile <- write_parquet(sqlite_output,
                                 sink = file.path(path_to_parquet,
                                                  parquetname))

  } else if (partition %in% c("yes")) {

    parquetfile <- write_dataset(sqlite_output,
                                 path = path_to_parquet,
                                 ...)

  }

  cli_alert_success(paste0("\nThe ",
                           table_in_sqlite,
                           " table from your sqlite file is available in parquet format under {path_to_parquet}"))

  return(invisible(parquetfile))

}
