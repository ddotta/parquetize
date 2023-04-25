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
#' To avoid overcharging R's RAM, the conversion can be done by chunk. One of arguments `max_memory` or `max_rows` must then be used.
#' This is very useful for huge tables and for computers with little RAM because the conversion is then done
#' with less memory consumption. For more information, see [here](https://ddotta.github.io/parquetize/articles/aa-conversions.html).
#'
#' @param path_to_table String that indicates the path to the input file (don't forget the extension).
#' @param path_to_parquet String that indicates the path to the directory where the parquet files will be stored.
#' @param columns Character vector of columns to select from the input file (by default, all columns are selected).
#' @param max_memory Memory size (in Mb) in which data of one parquet file should roughly fit.
#' @param max_rows Number of lines that defines the size of the chunk.
#' This argument can not be filled in if max_memory is used.
#' @param by_chunk DEPRECATED use max_memory or max_rows instead
#' @param chunk_size DEPRECATED use max_rows
#' @param chunk_memory_size DEPRECATED use max_memory
#' @param skip By default 0. This argument must be filled in if `by_chunk` is TRUE. Number of lines to ignore when converting.
#' @param partition String ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' Be careful, this argument can not be "yes" if `max_memory` or `max_rows` argument are not NULL.
#' @param encoding String that indicates the character encoding for the input file.
#' @param chunk_memory_sample_lines Number of lines to read to evaluate max_memory. Default to 10 000.
#' @param ... Additional format-specific arguments,  see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#'
#' @return Parquet files, invisibly
#'
#' @export
#'
#' @examples
#' # Conversion from a SAS file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempfile(fileext = ".parquet")
#' )
#'
#' # Conversion from a SPSS file to a single parquet file :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sav", package = "haven"),
#'   path_to_parquet = tempfile(fileext = ".parquet"),
#' )
#' # Conversion from a Stata file to a single parquet file without progress bar :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.dta", package = "haven"),
#'   path_to_parquet = tempfile(fileext = ".parquet")
#' )
#'
#' # Reading SPSS file by chunk (using `max_rows` argument)
#' # and conversion to multiple parquet files :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sav", package = "haven"),
#'   path_to_parquet = tempfile(),
#'   max_rows = 50,
#' )
#'
#' # Reading SPSS file by chunk (using `max_memory` argument)
#' # and conversion to multiple parquet files of 5 Kb when loaded (5 Mb / 1024)
#' # (in real files, you should use bigger value that fit in memory like 3000
#' # or 4000) :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sav", package = "haven"),
#'   path_to_parquet = tempfile(),
#'   max_memory = 5 / 1024,
#' )
#'
#' # Reading SAS file by chunk of 50 lines with encoding
#' # and conversion to multiple files :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempfile(),
#'   max_rows = 50,
#'   encoding = "utf-8"
#' )
#'
#' # Conversion from a SAS file to a single parquet file and select only
#' # few columns  :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempfile(fileext = ".parquet"),
#'   columns = c("Species","Petal_Length")
#' )
#'
#' # Conversion from a SAS file to a partitioned parquet file  :
#'
#' table_to_parquet(
#'   path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempfile(),
#'   partition = "yes",
#'   partitioning =  c("Species") # vector use as partition key
#' )
#'
#' # Reading SAS file by chunk of 50 lines
#' # and conversion to multiple files with zstd, compression level 10
#'
#' if (isTRUE(arrow::arrow_info()$capabilities[['zstd']])) {
#'   table_to_parquet(
#'     path_to_table = system.file("examples","iris.sas7bdat", package = "haven"),
#'     path_to_parquet = tempfile(),
#'     max_rows = 50,
#'     compression = "zstd",
#'     compression_level = 10
#'   )
#' }

table_to_parquet <- function(
    path_to_table,
    path_to_parquet,
    max_memory = NULL,
    max_rows = NULL,
    chunk_size = lifecycle::deprecated(),
    chunk_memory_size = lifecycle::deprecated(),
    columns = "all",
    by_chunk = lifecycle::deprecated(),
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
      details = "This argument is no longer needed, table_to_parquet will chunk if one of max_memory or max_rows is setted"
    )
  }

  if (!missing(chunk_size)) {
    lifecycle::deprecate_warn(
      when = "0.5.5",
      what = "table_to_parquet(chunk_size)",
      details = "This argument is deprecated, use max_rows."
    )
    max_rows <- chunk_size
  }

  if (!missing(chunk_memory_size)) {
    lifecycle::deprecate_warn(
      when = "0.5.5",
      what = "table_to_parquet(chunk_memory_size)",
      details = "This argument is deprecated, use max_memory."
    )
    max_memory <- chunk_memory_size
  }

  # Check if path_to_table is missing
  if (missing(path_to_table)) {
    cli_abort("Be careful, the argument path_to_table must be filled in", class = "parquetize_missing_argument")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    cli_abort("Be careful, the argument path_to_parquet must be filled in", class = "parquetize_missing_argument")
  }

  # Check if columns argument is a character vector
  if (isFALSE(is.vector(columns) & is.character(columns))) {
    cli_abort(c("Be careful, the argument columns must be a character vector",
                'You can use `all` or `c("col1", "col2"))`'),
              class = "parquetize_bad_type")
  }

  by_chunk <- !(missing(max_rows) & missing(max_memory))

  # Check if skip argument is correctly filled in by_chunk argument is TRUE
  if (by_chunk==TRUE & skip<0) {
    cli_abort("Be careful, if you want to do a conversion by chunk then the argument skip must be must be greater than 0",
              class = "parquetize_bad_argument")
  }

  # If by_chunk argument is TRUE and partition argument is equal to "yes" it fails
  if (by_chunk==TRUE & partition == "yes") {
    cli_abort("Be careful, when max_rows or max_memory are used, partition and partitioning can not be used", class = "parquetize_bad_argument")
  }


  # Closure to create read data
  closure_read_method <- function(encoding, columns) {
    method <- get_haven_read_function_for_file(path_to_table)
    function(path, n_max = Inf, skip = 0L) {
      method(path,
             n_max = n_max,
             skip = skip,
             encoding = encoding,
             col_select = if (identical(columns,"all")) everything() else all_of(columns))
    }
  }
  read_method <- closure_read_method(encoding = encoding, columns = columns)

  if (by_chunk) {
    ds <- write_parquet_by_chunk(
      read_method = read_method,
      input = path_to_table,
      path_to_parquet = path_to_parquet,
      max_rows = max_rows,
      max_memory = max_memory,
      chunk_memory_sample_lines = chunk_memory_sample_lines,
      ...
    )
    return(invisible(ds))
  }

  Sys.sleep(0.01)
  cli_progress_message("Reading data...")
  table_output <- read_method(path_to_table)

  parquetfile <- write_parquet_at_once(table_output, path_to_parquet, partition, ...)

  cli_alert_success("\nThe {path_to_table} file is available in parquet format under {path_to_parquet}")

  return(invisible(parquetfile))
}
