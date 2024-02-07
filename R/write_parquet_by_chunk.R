#' @name write_parquet_by_chunk
#'
#' @title read input by chunk on function and create dataset \cr
#'
#' @description Low level function that implements the logic to to read input file by chunk and write a
#'   dataset. \cr
#'
#'   It will:
#'
#' \itemize{
#' \item{calculate the number of row by chunk if needed;}
#' \item{loop over the input file by chunk;}
#' \item{write each output files.}
#' }
#'
#' @param read_method a method to read input files. This method take only three
#'   arguments
#'
#'   `input` : some kind of data. Can be a
#'   `skip` : the number of row to skip
#'   `n_max` : the number of row to return
#'
#'   This method will be called until it returns a dataframe/tibble with zero row.
#'
#'   If you need to pass more argument, you can use a
#'   [closure](http://adv-r.had.co.nz/Functional-programming.html#closures). See
#'   the last example.
#'
#'
#' @param input that indicates the path to the input. It can be anything you
#'   want but more often a file's path or a data.frame.
#' @param path_to_parquet String that indicates the path to the directory where
#'   the output parquet file or dataset will be stored.
#' @param max_memory Memory size (in Mb) in which data of one parquet file
#'   should roughly fit.
#' @param max_rows Number of lines that defines the size of the chunk. This
#'   argument can not be filled in if max_memory is used.
#' @param chunk_memory_sample_lines Number of lines to read to evaluate
#'   max_memory. Default to 10 000.
#' @param compression compression algorithm. Default "snappy".
#' @param compression_level compression level. Meaning depends on compression algorithm.
#' @param ... Additional format-specific arguments,  see
#'   \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'
#' @return a dataset as return by arrow::open_dataset
#' @export
#'
#' @examplesIf require("arrow", quietly = TRUE)
#'
#' # example with a dataframe
#'
#' # we create the function to loop over the data.frame
#'
#' read_method <- function(input, skip = 0L, n_max = Inf) {
#'   # if we are after the end of the input we return an empty data.frame
#'   if (skip+1 > nrow(input)) { return(data.frame()) }
#'
#'   # return the n_max row from skip + 1
#'   input[(skip+1):(min(skip+n_max, nrow(input))),]
#' }
#'
#' # we use it
#'
#' write_parquet_by_chunk(
#'   read_method = read_method,
#'   input = mtcars,
#'   path_to_parquet = tempfile(),
#'   max_rows = 10,
#' )
#'
#'
#' #
#' # Example with haven::read_sas
#' #
#'
#' # we need to pass two argument beside the 3 input, skip and n_max.
#' # We will use a closure :
#'
#' my_read_closure <- function(encoding, columns) {
#'   function(input, skip = OL, n_max = Inf) {
#'     haven::read_sas(data_file = input,
#'                     n_max = n_max,
#'                     skip = skip,
#'                     encoding = encoding,
#'                     col_select = all_of(columns))
#'   }
#' }
#'
#' # we initialize the closure
#'
#' read_method <- my_read_closure(encoding = "WINDOWS-1252", columns = c("Species", "Petal_Width"))
#'
#' # we use it
#' write_parquet_by_chunk(
#'   read_method = read_method,
#'   input = system.file("examples","iris.sas7bdat", package = "haven"),
#'   path_to_parquet = tempfile(),
#'   max_rows = 75,
#' )
#'
write_parquet_by_chunk <- function(
    read_method,
    input,
    path_to_parquet,
    max_rows = NULL,
    max_memory = NULL,
    chunk_memory_sample_lines = 10000,
    compression = "snappy",
    compression_level = NULL,
    ...
) {
  if (missing(read_method)) {
    cli_abort("Be careful, read_method argument is mandatory", class = "parquetize_missing_argument")
  }

  if (!is.function(read_method)) {
    cli_abort("Be careful, read_method must be a function", class = "parquetize_bad_argument")
  }

  if (missing(input)) {
    cli_abort("Be careful, input argument is mandatory", class = "parquetize_missing_argument")
  }

  # max_rows and max_memory can not be used together so fails
  if (!is.null(max_rows) & !is.null(max_memory)) {
    cli_abort("Be careful, max_rows and max_memory can not be used together", class = "parquetize_bad_argument")
  }

  if (is.null(max_rows)) {
    data <- read_method(input, n_max = chunk_memory_sample_lines)
    max_rows <- get_lines_for_memory(data,
                                     max_memory = max_memory)
  }

  dir.create(path_to_parquet, showWarnings = FALSE, recursive = TRUE)

  parquetname <- tools::file_path_sans_ext(basename(path_to_parquet))

  skip = 0
  while (TRUE) {
    Sys.sleep(0.01)
    cli_progress_message("Reading data...")

    tbl <- read_method(input, skip = skip, n_max = max_rows)
    if (nrow(tbl) != 0) {
      Sys.sleep(0.01)
      parquetizename <- glue::glue("{parquetname}-{skip+1}-{skip+nrow(tbl)}.parquet")
      cli_progress_message("Writing {parquetizename}...")
      arrow::write_parquet(tbl,
                  sink = file.path(path_to_parquet,
                                   parquetizename),
                  compression = compression,
                  compression_level = compression_level,
                    ...
      )
    }
    skip <- skip + nrow(tbl)
    if (nrow(tbl) < max_rows) { break }
  }

  Sys.sleep(0.01)
  cli_alert_success("\nData are available in parquet dataset under {path_to_parquet}/")

  invisible(arrow::open_dataset(path_to_parquet))
}
