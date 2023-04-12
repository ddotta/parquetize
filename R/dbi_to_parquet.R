#' @name dbi_to_parquet
#'
#' @title Convert a SQL Query on a DBI connection to parquet format
#'
#' @description This function allows to convert a SQL query from a DBI to parquet format.\cr
#'
#' It handles all DBI supported databases.
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
#' Examples explain how to convert a query to a chunked dataset
#'
#' @param conn A DBIConnection object, as return by DBI::dbConnect
#' @param sql_query a character string containing an SQL query (this argument is passed to DBI::dbSendQuery)
#' @inheritParams table_to_parquet
#' @param parquetname string the base file name used. If not set, will use a contraction of the query.
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @importFrom DBI dbConnect dbListTables dbDisconnect dbHasCompleted dbSendQuery dbFetch dbClearResult
#' @importFrom cli cli_abort cli_alert_success cli_alert_warning
#' @export
#'
#' @examples
#'
#' # Conversion from a sqlite dbi connection to a single parquet file :
#'
#' dbi_connection <- DBI::dbConnect(RSQLite::SQLite(),
#'   system.file("extdata","iris.sqlite",package = "parquetize"))
#'
#' # Reading iris table from local sqlite database
#' # and conversion to one parquet file :
#'
#' dbi_to_parquet(
#'   conn = dbi_connection,
#'   sql_query = "SELECT * FROM iris",
#'   path_to_parquet = tempdir(),
#'   parquetname = "iris"
#' )
#'
#' # Reading iris table from local sqlite database by chunk (using
#' # `max_memory` argument) and conversion to multiple parquet files
#'
#' dbi_to_parquet(
#'   conn = dbi_connection,
#'   sql_query = "SELECT * FROM iris",
#'   path_to_parquet = tempdir(),
#'   parquetname = "iris",
#'   max_memory = 2 / 1024
#' )
#'
#' # Using chunk and partition together is not possible directly but easy to do :
#' # Reading iris table from local sqlite database by chunk (using
#' # `max_memory` argument) and conversion to arrow dataset partitioned by
#' # species
#'
#' # get unique values of column "iris from table "iris"
#' partitions <- get_partitions(dbi_connection, table = "iris", column = "Species")
#'
#' # loop over those values
#' for (species in partitions) {
#'   dbi_to_parquet(
#'     conn = dbi_connection,
#'     # use glue_sql to create the query filtering the partition
#'     sql_query = glue::glue_sql("SELECT * FROM iris where Species = {species}",
#'                                .con = dbi_connection),
#'     # add the partition name in the output dir to respect parquet partition schema
#'     path_to_parquet = file.path(tempdir(), "iris", paste0("Species=", species)),
#'     max_memory = 2 / 1024,
#'     parquetname = "iris-"
#'   )
#' }
#'
#' # If you need a more complicated query to get your partitions, you can use
#' # dbGetQuery directly :
#' col_to_partition <- DBI::dbGetQuery(dbi_connection, "SELECT distinct(`Species`) FROM `iris`")[,1]
#'
dbi_to_parquet <- function(
    conn,
    sql_query,
    path_to_parquet,
    parquetname,
    max_memory,
    max_rows,
    chunk_memory_sample_lines = 10000,
    partition = "no",
    ...
) {
  if (missing(conn)) {
    cli_abort("Be careful, the argument conn must be filled in", class = "parquetize_missing_argument")
  }

  # Check if path_to_parquet is missing
  if (missing(sql_query)) {
    cli_abort("Be careful, the argument sql_query must be filled in", class = "parquetize_missing_argument")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_abort("Be careful, the argument path_to_parquet must be filled in", class = "parquetize_missing_argument")
  }

  # Check if path_to_parquet exists
  dir.create(path_to_parquet, recursive = TRUE, showWarnings = FALSE)

  if (missing(parquetname)) {
    parquetname <- stringify_sql(sql_query)
    cli_alert_warning("Argument 'parquetname' is missing, using '{parquetname}'")
  }

  by_chunk <- !(missing(max_rows) & missing(max_memory))

  if (by_chunk == TRUE) {
    if (missing(max_rows)) {
      # create the query and send it to the DB
      result <- dbSendQuery(conn, sql_query)
      # fetch a sample of result
      data <- dbFetch(result, n = chunk_memory_sample_lines)
      # close the query in DB
      dbClearResult(result)

      max_rows <- get_lines_for_memory(data,
                                       max_memory = max_memory)
    }

    result <- dbSendQuery(conn, sql_query)

    skip <- 0
    while (!dbHasCompleted(result)) {
      Sys.sleep(0.01)
      cli_progress_message("Reading data...")

      data <- dbFetch(result, n = max_rows)
      parquetizename <- paste0(parquetname,sprintf("%d",skip+1),"-",sprintf("%d",skip+nrow(data)),".parquet")

      Sys.sleep(0.01)
      cli_progress_message("Writing data in {parquetizename}...")
      write_parquet(data,
                    sink = file.path(path_to_parquet,
                                     parquetizename),
                    ...
      )
      skip <- skip + nrow(data)
    }

    dbClearResult(result)
    cli_alert_success("\nThe request '{sql_query}' is available in the dataset directory {path_to_parquet}/")
    return(invisible(TRUE))
  }

  result <- dbSendQuery(conn, sql_query)

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")
  output <- dbFetch(result)
  dbClearResult(result)

  Sys.sleep(0.01)
  cli_progress_message("Writing data...")

  parquetname <- paste0(basename(parquetname), ".parquet")
  parquetfile <- write_data_in_parquet(output, path_to_parquet, parquetname, partition, ...)

  cli_alert_success("The request '{sql_query}' from your conn is available in parquet format under {path_to_parquet}")
  return(invisible(parquetfile))
}



#' @name stringify_sql
#'
#' @title Convert a SQL query string in a filename's string
#'
#' @description
#' This function take a SQL query string and replace all chararacters but a-z, A-Z and 0-9 by "_"
#'
#' @param sql_query
#'
#' @return a string suitable to be a file name
#' @export
#'
#' @keywords internal
stringify_sql <- function(sql_query) {
  gsub("[^a-zA-Z0-9]+", "_", sql_query, perl = TRUE)
}
