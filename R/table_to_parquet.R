#' Convert a csv table to parquet format
#'
#' This function allows to convert a csv table to parquet format. \cr
#'
#' Several conversion possibilities are offered :
#'
#'\itemize{
#'
#' \item{From a locally stored file. The argument `path_to_csv` must then be used;}
#' \item{From a URL. The argument `url_to_csv` must then be used.}
#'
#' }
#'
#' @param path_to_table string that indicates the path to the csv file (don't forget the extension).
#' @param path_to_parquet string that indicates the path to the directory where the parquet files will be stored.
#' @param nb_rows By default NULL. Number of rows to process at once. This is the number of lines put into R's RAM and the number of lines written to disk for the parquet file.
#' @param partition string ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' @param ... additional format-specific arguments (e.g `"encoding"`), see [arrow::write_parquet()] and [arrow::write_dataset()] for more informations.
#'
#' @return Parquet files, invisibly
#'
#' @importFrom haven read_sas read_sav read_dta
#' @importFrom arrow write_parquet
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # Conversion from a SAS file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = "Data/postp.sas7bdat",
#'   path_to_parquet = "Data",
#' )
#'
#' # Conversion from a SPSS file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = "Data/postp.sav",
#'   path_to_parquet = "Data"
#' )
#'
#' # Conversion from a Stata file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = "Data/postp.dta"
#'   path_to_parquet = "Data",
#' )
#'
#' # Conversion from a big SAS file to a single parquet file by chunk :
#'
#' table_to_parquet(
#'   path_to_table = "Data/postp.sas7bdat",
#'   path_to_parquet = "Data",
#'   nb_rows = 100000
#' )
#'
#' # Conversion from a SAS file to a partitioned parquet file :
#'
#' table_to_parquet(
#'   path_to_table = "Data/postp.sas7bdat"
#'   path_to_parquet = "Data",
#'   partition = "yes",
#'   partitioning =  c("REG")
#' )
#' }

table_to_parquet <- function(
    path_to_table,
    path_to_parquet,
    nb_rows = NULL,
    partition = "no",
    ...
) {

  # Check if path_to_table is missing
  if (missing(path_to_table)) {
    stop("Be careful, the argument path_to_table must be filled in")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    stop("Be careful, the argument path_to_parquet must be filled in")
  }

  extension <- sub(".*\\.","",sub(".*/","", path_to_table))

  if (extension %in% c("sas7bdat")) {

    file_format <- "SAS"

    if (is.null(nb_rows)) {

      table_output <- read_sas(path_to_table)

    } else if (is.null(nb_rows)==FALSE) {

      liste_tables <- vector("list")
      part <- 1
      step <- 0
      continue <- TRUE
      while(continue) {
        liste_tables[[part]] <-
          read_sas(path_to_table,
                   skip = step,
                   n_max = nb_rows,
                   ...)
        if (nrow(liste_tables[[part]]) > 0) {
          part <- part + 1
          step <- step + nb_rows
          continue <- TRUE
        } else {
          continue <- FALSE
        }

      }

      table_output <- do.call(rbind,liste_tables)

    }

  } else if (extension %in% c("sav")) {

    file_format <- "SPSS"
    table_output <- read_sav(path_to_table)

  } else if (extension %in% c("dta")) {

    file_format <- "Stata"
    table_output <- read_dta(path_to_table)

  }

  # Remove all attributes
  table_output[] <- lapply(table_output, function(x) {attributes(x) <- NULL; x})

  parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_table)),".parquet")


  if (partition %in% c("no")) {

    parquetfile <- write_parquet(table_output,
                                 sink = file.path(path_to_parquet,
                                                  parquetname),
                                 chunk_size = nb_rows,
                                 ...)

  } else if (partition %in% c("yes")) {

    parquetfile <- write_dataset(table_output,
                                 path = path_to_parquet,
                                 ...)

  }

  message(paste0("The ", file_format," file is available in parquet format under ",path_to_parquet))

  return(invisible(parquetfile))

}

