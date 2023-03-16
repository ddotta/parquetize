#' @name table_to_parquet
#'
#' @title Convert an input file to parquet format
#'
#' @description This function allows to convert an input file to parquet format. \cr
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
#' To avoid overcharging R's RAM, the conversion can be done by chunk. Argument `by_chunk` must then be used.
#' This is very useful for huge tables and for computers with little RAM because the conversion is then done
#' with less memory consumption. For more information, see [here](https://ddotta.github.io/parquetize/articles/aa-conversions.html).
#'
#' @param path_to_table String that indicates the path to the input file (don't forget the extension).
#' @param path_to_parquet String that indicates the path to the directory where the parquet files will be stored.
#' @param columns Character vector of columns to select from the input file (by default, all columns are selected).
#' @param by_chunk Boolean. By default FALSE. If TRUE then it means that the conversion will be done by chunk.
#' @param chunk_memory_size Memory size (in Mb) in which data of one parquet file should roughly fit. For very small size, data could be a bit larger than given memory.
#' @param chunk_memory_sample_lines Number of lines to read to evaluate chunk_memory_size. Default to 10 000.
#' @param chunk_size Number of lines that defines the size of the chunk.
#' This argument must be filled in if `by_chunk` is TRUE (otherwise ignored).
#' This argument can not be filled in if chunk_memory_size is used.
#' @param skip By default 0. This argument must be filled in if `by_chunk` is TRUE. Number of lines to ignore when converting.
#' @param partition String ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' Be careful, this argument can not be "yes" if `by_chunk` argument is not NULL.
#' @param encoding String that indicates the character encoding for the input file.
#' @param ... Additional format-specific arguments,  see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#'
#' @return Parquet files, invisibly
#'
#' @importFrom haven read_sas read_sav read_dta
#' @importFrom arrow write_parquet write_dataset
#' @importFrom cli cli_alert_danger cli_progress_message cli_alert_success cli_progress_bar
#' @import dplyr
#' @export
#'
#' @examples
#' # Conversion from a SAS file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir()
#' )
#'
#' # Conversion from a SPSS file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sav", package = "haven"),
#'   path_to_parquet = tempdir(),
#' )
#' # Conversion from a Stata file to a single parquet file without progress bar :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.dta", package = "haven"),
#'   path_to_parquet = tempdir()
#' )
#'
#' # Reading SPSS file by chunk (using `chunk_size` argument)
#' # and conversion to multiple parquet files :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sav", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   by_chunk = TRUE,
#'   chunk_size = 50,
#' )
#'
#' # Reading SPSS file by chunk (using `chunk_memory_size` argument)
#' # and conversion to multiple parquet files of 5 Kb when loaded (5 Mb / 1024)
#' # (in real files, you should use bigger value that fit in memory like 3000
#' # or 4000) :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sav", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   by_chunk = TRUE,
#'   chunk_memory_size = 5 / 1024,
#' )
#'
#' # Reading SAS file by chunk with encoding
#' # and conversion to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   by_chunk = TRUE,
#'   chunk_size = 50,
#'   encoding = "utf-8"
#' )
#'
#' # Reading SAS file by chunk
#' # and conversion to multiple files with zstd, compression level 10
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   by_chunk = TRUE,
#'   chunk_size = 50,
#'   compression = "zstd",
#'   compression_level = 10
#' )
#'
#' # Conversion from a SAS file to a single parquet file and select only
#' # few columns  :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   columns = c("Species","Petal_Length")
#' )
#'
#' # Conversion from a SAS file to a partitioned parquet file  :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   partition = "yes",
#'   partitioning =  c("Species") # vector use as partition key
#' )

table_to_parquet <- function(
    path_to_table,
    path_to_parquet,
    columns = "all",
    by_chunk = FALSE,
    chunk_memory_size,
    chunk_memory_sample_lines = 10000,
    chunk_size,
    skip = 0,
    partition = "no",
    encoding = NULL,
    ...
) {

  # Check if path_to_table is missing
  if (missing(path_to_table)) {
    cli_alert_danger("Be careful, the argument path_to_table must be filled in")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_alert_danger("Be careful, the argument path_to_parquet must be filled in")
  }

  # Check if path_to_parquet exists
  if (dir.exists(path_to_parquet)==FALSE) {
    dir.create(path_to_parquet, recursive = TRUE)
  }

  # Check if columns argument is a character vector
  if (isFALSE(is.vector(columns) & is.character(columns))) {
    cli_alert_danger("Be careful, the argument columns must be a character vector")
  }

  # Check if chunk_size or check_memory_size argument is filled in by_chunk argument is TRUE
  if (by_chunk==TRUE & missing(chunk_size) & missing(chunk_memory_size)) {
    cli_alert_danger("Be careful, if you want to do a conversion by chunk one of the arguments chunk_memory_size or chunk_size must be filled in")
  }

  # Check if skip argument is correctly filled in by_chunk argument is TRUE
  if (by_chunk==TRUE & skip<0) {
    cli_alert_danger("Be careful, if you want to do a conversion by chunk then the argument skip must be must be greater than 0")
    stop("")
  }

  # If by_chunk argument is TRUE and partition argument is equal to "yes" it fails
  if (by_chunk==TRUE & partition == "yes") {
    cli_alert_danger("Be careful, when by_chunk is TRUE partition and partitioning can not be used")
    stop("")
  }

  # chunk_size and chunk_memory_size can not be used together so fails
  if (by_chunk==TRUE & !missing(chunk_size) & !missing(chunk_memory_size)) {
    cli_alert_danger("Be careful, chunk_size and chunk_memory_size can not be used together")
    stop("")
  }

  extension <- tools::file_ext(path_to_table)
  parquetname <- gsub(paste0(extension, "$"), "parquet", basename(path_to_table))

  file_format <- get_file_format(path_to_table)

  if (isTRUE(by_chunk)) {
    if (missing(chunk_size)) {
      chunk_size <- get_lines_for_memory(path_to_table,
                                         chunk_memory_size = chunk_memory_size,
                                         sample_lines = chunk_memory_sample_lines)
    }

    if (isTRUE(bychunk(path_to_table, path_to_parquet, skip = skip, chunk_size = chunk_size, ...))) {
      Recall(path_to_table, path_to_parquet, by_chunk=TRUE, skip = skip + chunk_size, chunk_size = chunk_size, ...)
    }
    return(invisible(TRUE))
  }

  read_method <- get_read_function_for_file(path_to_table)

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  # If we want to keep all columns
  if (identical(columns,"all")) {
    table_output <- read_method(path_to_table,
                                encoding = encoding)
    # If you select the columns to be kept
  } else {
    table_output <- read_method(path_to_table,
                                encoding = encoding,
                                col_select = columns)
  }

  table_output[] <- lapply(table_output, function(x) {attributes(x) <- NULL; x})


  if (partition == "no") {
    Sys.sleep(0.01)

    cli_progress_message("Writing data...")

    parquetfile <- write_parquet(table_output,
                                 sink = file.path(path_to_parquet,
                                                  parquetname),
                                 ...)

    cli_alert_success("\nThe {file_format} file is available in parquet format under {path_to_parquet}")

  } else if (partition == "yes") {

    Sys.sleep(0.01)
    cli_progress_message("Writing data...")

    parquetfile <- write_dataset(table_output,
                                 path = path_to_parquet,
                                 ...)

    cli_alert_success("\nThe {file_format} file is available in parquet format under {path_to_parquet}")

  }

}
