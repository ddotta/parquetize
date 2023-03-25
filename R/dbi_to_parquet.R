#' @name dbi_to_parquet
#'
#' @title Convert a SQL Query on DBI connection to parquet format
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
#' @param dbi_connection DBI object (as return by a call to DBI::dbConnect) connection to the database
#' @param sql_query string the sql query used to get data, this argument is passed to DBI::dbSendQuery
#' @inheritParams table_to_parquet
#' @param parquetname string the base file name used. If not set, will use a contraction of the query.
#' @param sql_params list parameters to bind to sql query. This argument is passed to DBI::dbBind on the result of DBI::dbSendQuery
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @importFrom DBI dbConnect dbReadTable dbListTables dbDisconnect dbHasCompleted dbSendQuery dbFetch dbClearResult dbBind
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
#' # Reading iris tavble from local sqlite database and
#' # and conversion to one parquet file :
#'
#' dbi_to_parquet(
#'   dbi_connection = dbi_connection,
#'   sql_query = "SELECT * FROM iris",
#'   path_to_parquet = tempdir(),
#'   parquetname = "iris"
#' )
#'
#' # Reading iris table from local sqlite database by chunk (using
#' # `chunk_memory_size` argument) and conversion to multiple parquet files
#'
#' dbi_to_parquet(
#'   dbi_connection = dbi_connection,
#'   sql_query = "SELECT * FROM iris",
#'   path_to_parquet = tempdir(),
#'   parquetname = "iris",
#'   chunk_memory_size = 2 / 1024
#' )
#'
#' # Using chunk and partition together is not possible directly but easy to do :
#' # Reading iris table from local sqlite database by chunk (using
#' # `chunk_memory_size` argument) and conversion to arrow dataset partitioned by
#' # species
#'
#' partitions <- DBI::dbGetQuery(dbi_connection, "SELECT distinct(Species) FROM iris")
#'
#' for (species in partitions[,1]) {
#'   dbi_to_parquet(
#'     dbi_connection = dbi_connection,
#'     # you can find information on place holder on this page
#'     # https://solutions.posit.co/connections/db/best-practices/run-queries-safely
#'     sql_query = paste0("SELECT * FROM iris where Species = $species"),
#'     sql_params = list(species = c(species)),
#'     path_to_parquet = file.path(tempdir(), "iris", paste0("Species=", species)),
#'     chunk_memory_size = 2 / 1024,
#'     parquetname = "iris-"
#'   )
#' }
#'
dbi_to_parquet <- function(
    dbi_connection,
    sql_query,
    path_to_parquet,
    parquetname,
    chunk_memory_size,
    chunk_size,
    sql_params = NULL,
    chunk_memory_sample_lines = 10000,
    partition = "no",
    ...
) {

  if (missing(dbi_connection)) {
    cli_abort("Be careful, the argument dbi_connection must be filled in", class = "parquetize_missing_argument")
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

  by_chunk <- !(missing(chunk_size) & missing(chunk_memory_size))

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  if (by_chunk == TRUE) {
    if (missing(chunk_size)) {
      result <- dbSendQuery(dbi_connection, sql_query)
      if (!is.null(sql_params)) dbBind(result, sql_params)

      data <- dbFetch(result, n = chunk_memory_sample_lines)
      dbClearResult(result)

      chunk_size <- get_lines_for_memory(data,
                                         chunk_memory_size = chunk_memory_size)
    }

    result <- dbSendQuery(dbi_connection, sql_query)
    if (!is.null(sql_params)) dbBind(result, sql_params)

    ln <- 0
    while (!dbHasCompleted(result)) {
      data <- dbFetch(result, n = chunk_size)
      parquetizename <- paste0(parquetname,sprintf("%d",(ln*chunk_size)+1),"-",sprintf("%d",(ln*chunk_size)+nrow(data)),".parquet")
      write_parquet(data,
                    sink = file.path(path_to_parquet,
                                     parquetizename),
                    ...
      )
      cli_alert_success("\nThe request '{sql_query}' is available in parquet format under {path_to_parquet}/{parquetizename}")
      ln <- ln + 1
    }

    dbClearResult(result)
    return(invisible(TRUE))
  }

  result <- dbSendQuery(dbi_connection, sql_query)
  if (!is.null(sql_params)) dbBind(result, sql_params)

  output <- dbFetch(result)
  dbClearResult(result)

  Sys.sleep(0.01)
  cli_progress_message("Writing data...")

  parquetname <- paste0(basename(parquetname), ".parquet")
  parquetfile <- write_data_in_parquet(output, path_to_parquet, parquetname, partition, ...)

  cli_alert_success("The request '{sql_query}' from your dbi_connection is available in parquet format under {path_to_parquet}")
  return(invisible(parquetfile))

}

function(con, sql_query, sql_params) {
  result <- dbSendQuery(con, sql_query)
  if (!is.null(sql_params)) dbBind(result, sql_params)
  result
}

stringify_sql <- function(sql_query) {
  gsub("[^a-zA-Z0-9]+", "_", sql_query, perl = TRUE)
}
