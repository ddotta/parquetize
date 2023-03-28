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
#' To avoid overcharging R's RAM, the conversion can be done by chunk. One of arguments `chunk_memory_size` or `chunk_size` must then be used.
#' This is very useful for huge tables and for computers with little RAM because the conversion is then done
#' with less memory consumption. For more information, see [here](https://ddotta.github.io/parquetize/articles/aa-conversions.html).
#'
#' @param path_to_table String that indicates the path to the input file (don't forget the extension).
#' @param path_to_parquet String that indicates the path to the directory where the parquet files will be stored.
#' @param columns Character vector of columns to select from the input file (by default, all columns are selected).
#' @param by_chunk DEPRECATED use chunk_memory_size or chunk_memory instead
#' @param chunk_memory_size Memory size (in Mb) in which data of one parquet file should roughly fit. For very small size, data could be a bit larger than given memory.
#' @param chunk_size Number of lines that defines the size of the chunk.
#' This argument must be filled in if `by_chunk` is TRUE (otherwise ignored).
#' This argument can not be filled in if chunk_memory_size is used.
#' @param skip By default 0. This argument must be filled in if `by_chunk` is TRUE. Number of lines to ignore when converting.
#' @param partition String ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' Be careful, this argument can not be "yes" if `chunk_memory_size` or `chunk_size` argument are not NULL.
#' @param encoding String that indicates the character encoding for the input file.
#' @param chunk_memory_sample_lines Number of lines to read to evaluate chunk_memory_size. Default to 10 000.
#' @param ... Additional format-specific arguments,  see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#'
#' @return Parquet files, invisibly
#'
#' @importFrom haven read_sas read_sav read_dta
#' @importFrom arrow write_parquet write_dataset
#' @importFrom cli cli_alert_danger cli_progress_message cli_alert_success cli_progress_bar cli_alert_info
#' @importFrom tidyselect all_of everything
#' @importFrom lifecycle deprecated deprecate_warn
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
#'   chunk_memory_size = 5 / 1024,
#' )
#'
#' # Reading SAS file by chunk of 50 lines with encoding
#' # and conversion to multiple files :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   chunk_size = 50,
#'   encoding = "utf-8"
#' )
#'
#' # Reading SAS file by chunk of 50 lines
#' # and conversion to multiple files with gzip, compression level 10
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempdir(),
#'   chunk_size = 50,
#'   compression = "gzip",
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
    chunk_memory_size,
    chunk_size,
    columns = "all",
    by_chunk = deprecated(),
    skip = 0,
    partition = "no",
    encoding = NULL,
    chunk_memory_sample_lines = 10000,
    ...
) {
  if (!missing(by_chunk)) {
    lifecycle::deprecate_warn(
      when = "0.5.5",
      what = "table_to_parquet(by_chunk)",
      details = "This argument is no longer needed, table_to_parquet will chunk if one of chunk_memory_size or chunk_size is setted"
    )
  }

  # Check if path_to_table is missing
  if (missing(path_to_table)) {
    cli_alert_danger("Be careful, the argument path_to_table must be filled in")
    stop("")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_alert_danger("Be careful, the argument path_to_parquet must be filled in")
    stop("")
  }

  dir.create(path_to_parquet, recursive = TRUE, showWarnings = FALSE)

  # Check if columns argument is a character vector
  if (isFALSE(is.vector(columns) & is.character(columns))) {
    cli_alert_danger("Be careful, the argument columns must be a character vector")
    cli_alert_info('You can use `all` or `c("col1", "col2"))`')
    stop("")
  }

  by_chunk <- !(missing(chunk_size) & missing(chunk_memory_size))

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
  if (!missing(chunk_size) & !missing(chunk_memory_size)) {
    cli_alert_danger("Be careful, chunk_size and chunk_memory_size can not be used together")
    stop("")
  }

  if (by_chunk) {
    read_method <- get_read_function_for_file(path_to_table)

    if (missing(chunk_size)) {
      data <- read_method(path_to_table, n_max = chunk_memory_sample_lines)
      chunk_size <- get_lines_for_memory(data,
                                         chunk_memory_size = chunk_memory_size)
    }

    parquetname <- paste0(gsub("\\..*","",basename(path_to_table)))

    skip = 0
    while (TRUE) {
      tbl <- read_method(path_to_table,
                         skip = skip,
                         n_max = chunk_size)

      if (nrow(tbl) != 0) {
        parquetizename <- paste0(parquetname,sprintf("%d",skip+1),"-",sprintf("%d",skip+nrow(tbl)),".parquet")
        write_parquet(tbl,
                      sink = file.path(path_to_parquet,
                                       parquetizename),
                      ...
        )
        cli_alert_success("\nThe {get_file_format(path_to_table)} file is available in parquet format under {path_to_parquet}/{parquetizename}")
      }
      skip <- skip + chunk_size

      if (nrow(tbl) < chunk_size) { return(invisible(TRUE)) }
    }
  }
  read_method <- get_read_function_for_file(path_to_table)

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")

  table_output <- read_method(
    path_to_table,
    encoding = encoding,
    col_select = if (identical(columns,"all")) everything() else all_of(columns)
  )

  table_output[] <- lapply(table_output, function(x) {attributes(x) <- NULL; x})

  Sys.sleep(0.01)
  cli_progress_message("Writing data...")

  parquetname <- get_parquet_file_name(path_to_table)
  parquetfile <- write_data_in_parquet(table_output, path_to_parquet, parquetname, partition, ...)

  cli_alert_success("\nThe {get_file_format(path_to_table)} file is available in parquet format under {path_to_parquet}")

  return(invisible(parquetfile))
}
