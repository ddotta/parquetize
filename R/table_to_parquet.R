#' Convert an input file to parquet format
#'
#' This function allows to convert an input file to parquet format. \cr
#'
#' It handles SAS, SPSS and Stata files in a same function. There is only one function to use for these 3 cases.
#' For these 3 cases, the function guesses the data format using the extension of the input file (in the `path_to_table` argument). \cr
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
#' To avoid overcharging R's RAM, the reading of input files can be done by chunk. Argument  `nb_rows` must then be used.
#'
#' @param path_to_table string that indicates the path to the input file (don't forget the extension).
#' @param path_to_parquet string that indicates the path to the directory where the parquet files will be stored.
#' @param nb_rows By default NULL. Number of rows to process at once. This is the number of lines put into R's RAM and the number of lines written to disk for the parquet file.
#' @param partition string ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' @param encoding string that indicates the character encoding for the input file.
#' @param ... additional format-specific arguments, see [arrow::write_parquet()](https://arrow.apache.org/docs/r/reference/write_parquet.html) and [arrow::write_dataset()](https://arrow.apache.org/docs/r/reference/write_dataset.html) for more informations.
#' @param progressbar string () ("yes" or "no" - by default) that indicates whether you want a progress bar to display
#'
#' @return Parquet files, invisibly
#'
#' @importFrom haven read_sas read_sav read_dta
#' @importFrom arrow write_parquet write_dataset
#' @importFrom utils txtProgressBar setTxtProgressBar
#' @export
#'
#' @examples
#' # Conversion from a SAS file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   progressbar = "no"
#' )
#'
#' # Conversion from a SPSS file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sav", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   progressbar = "no"
#' )
#' # Conversion from a Stata file to a single parquet file without progress bar :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.dta", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   progressbar = "no"
#' )
#'
#' # Reading SAS file by chunk and with encoding and conversion from a SAS file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   nb_rows = 50,
#'   encoding = "utf-8",
#'   progressbar = "no"
#' )
#'
#' # Conversion from a SAS file to a partitioned parquet file  :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   partition = "yes",
#'   partitioning =  c("Species"), # vector use as partition key
#'   progressbar = "no"
#' )
#'
#' # Reading SAS file by chunk and conversion from a SAS file to a partitioned parquet file :
#'
#' table_to_parquet(
#' path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#' path_to_parquet = tempdir(),
#' nb_rows = 50,
#' partition = "yes",
#' partitioning =  c("Species"), # vector use as partition key
#' progressbar = "no"
#' )

table_to_parquet <- function(
    path_to_table,
    path_to_parquet,
    nb_rows = NULL,
    partition = "no",
    encoding = NULL,
    progressbar = "yes",
    ...
) {

  if (progressbar %in% c("yes")) {
    # Initialize the progress bar
    conversion_progress <- txtProgressBar(style = 3)
  }

  # Check if path_to_table is missing
  if (missing(path_to_table)) {
    stop("Be careful, the argument path_to_table must be filled in")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    stop("Be careful, the argument path_to_parquet must be filled in")
  }

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 1)

  extension <- sub(".*\\.","",sub(".*/","", path_to_table))

  if (extension %in% c("sas7bdat")) {

    file_format <- "SAS"

    if (is.null(nb_rows)) {

      table_output <- read_sas(data_file = path_to_table,
                               encoding = encoding)

      update_progressbar(pbar = progressbar,
                         name_progressbar = conversion_progress,
                         value = 6)

    } else if (is.null(nb_rows)==FALSE) {

      table_output <- read_by_chunk(format_export = file_format,
                                    path = path_to_table,
                                    nb_rows = nb_rows,
                                    encoding = encoding)

      update_progressbar(pbar = progressbar,
                         name_progressbar = conversion_progress,
                         value = 6)
    }

  } else if (extension %in% c("sav")) {

    file_format <- "SPSS"

    if (is.null(nb_rows)) {

      table_output <- read_sav(file = path_to_table,
                               encoding = encoding)

      update_progressbar(pbar = progressbar,
                         name_progressbar = conversion_progress,
                         value = 6)

    } else if (is.null(nb_rows)==FALSE) {

      table_output <- read_by_chunk(format_export = file_format,
                                    path = path_to_table,
                                    nb_rows = nb_rows,
                                    encoding = encoding)

      update_progressbar(pbar = progressbar,
                         name_progressbar = conversion_progress,
                         value = 6)

    }

  } else if (extension %in% c("dta")) {

    file_format <- "Stata"

    if (is.null(nb_rows)) {

      table_output <- read_dta(file = path_to_table,
                               encoding = encoding)

      update_progressbar(pbar = progressbar,
                         name_progressbar = conversion_progress,
                         value = 6)

    } else if (is.null(nb_rows)==FALSE) {

      table_output <- read_by_chunk(format_export = file_format,
                                    path = path_to_table,
                                    nb_rows = nb_rows,
                                    encoding = encoding)

      update_progressbar(pbar = progressbar,
                         name_progressbar = conversion_progress,
                         value = 6)

    }

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

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 10)

  message(paste0("\nThe ", file_format," file is available in parquet format under ",path_to_parquet))

  return(invisible(parquetfile))

}

