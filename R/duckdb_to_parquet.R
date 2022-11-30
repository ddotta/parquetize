#' Convert a duckdb file to parquet format
#'
#' This function allows to convert a table from a duckdb file to parquet format. \cr
#' The following extensions are supported : "duckdb" or "db". \cr
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
#' @param path_to_duckdb string that indicates the path to the duckdb file
#' @param table_in_duckdb string that indicates the name of the table to convert in the duckdb file
#' @param path_to_parquet string that indicates the path to the directory where the parquet file will be stored
#' @param partition string ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' @param progressbar string () ("yes" or "no" - by default) that indicates whether you want a progress bar to display
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @importFrom DBI dbConnect dbReadTable dbListTables
#' @importFrom duckdb duckdb duckdb_shutdown
#' @importFrom arrow write_parquet write_dataset
#' @export
#'
#' @examples
#'
#' # Conversion from a local duckdb file to a single parquet file :
#'
#' duckdb_to_parquet(
#'   path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize"),
#'   table_in_duckdb = "iris",
#'   path_to_parquet = tempdir(),
#'   progressbar = "no"
#' )
#'
#' # Conversion from a local duckdb file to a partitioned parquet file  :
#'
#' duckdb_to_parquet(
#'   path_to_duckdb = system.file("extdata","iris.duckdb",package = "parquetize"),
#'   table_in_duckdb = "iris",
#'   path_to_parquet = tempdir(),
#'   progressbar = "no",
#'   partition = "yes",
#'   partitioning =  c("Species")
#' )

duckdb_to_parquet <- function(
    path_to_duckdb,
    table_in_duckdb,
    path_to_parquet,
    partition = "no",
    progressbar = "yes",
    ...
) {


  if (progressbar %in% c("yes")) {
    # Initialize the progress bar
    conversion_progress <- txtProgressBar(style = 3)
  }

  # Check if path_to_duckdb is missing
  if (missing(path_to_duckdb)) {
    stop("Be careful, the argument path_to_duckdb must be filled in")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    stop("Be careful, the argument path_to_parquet must be filled in")
  }

  # Check if path_to_parquet exists
  if (dir.exists(path_to_parquet)==FALSE) {
    dir.create(path_to_parquet, recursive = TRUE)
  }

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 1)


  con_duckdb <- DBI::dbConnect(duckdb::duckdb(),
                               path_to_duckdb)

  # Check if table_in_duckdb exists in duckdb file
  list_table <- DBI::dbListTables(con_duckdb)
  if (!(table_in_duckdb %in% list_table)==TRUE) {
    stop("Be careful, the table filled in the table_in_duckdb argument does not exist in your duckdb file")
  }

  duckdb_output <- DBI::dbReadTable(con_duckdb, table_in_duckdb)

  DBI::dbDisconnect(con_duckdb, shutdown=TRUE)

  if (file.exists(paste0(path_to_duckdb,".wal"))) {
    file.remove(paste0(path_to_duckdb,".wal"))
  }

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 6)

  parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_duckdb)),".parquet")

  if (partition %in% c("no")) {

    parquetfile <- write_parquet(duckdb_output,
                                 sink = file.path(path_to_parquet,
                                                  parquetname))

  } else if (partition %in% c("yes")) {

    parquetfile <- write_dataset(duckdb_output,
                                 path = path_to_parquet,
                                 ...)

  }

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 10)

  message(paste0("\nThe ", table_in_duckdb," table from your duckdb file is available in parquet format under ",path_to_parquet))

  return(invisible(parquetfile))

}
