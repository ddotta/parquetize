#' @name bychunk
#'
#' @title Utility function that read and write data by chunk
#'
#' @param file_format file format
#' @param path_to_table string that indicates the path to the input file (don't forget the extension).
#' @param path_to_parquet string that indicates the path to the directory where the parquet files will be stored.
#' @param chunk_size Number of lines that defines the size of the chunk.
#' @param skip Number of lines to ignore when converting.
#'
#'
#' @noRd
bychunk <- function(file_format, path_to_table, path_to_parquet, chunk_size, skip, ...) {

  if (file_format %in% c("SAS")) {

    tbl <- read_sas(data_file = path_to_table,
                    skip = skip,
                    n_max = chunk_size)
  } else if (file_format %in% c("SPSS")) {

    tbl <- read_sav(file = path_to_table,
                    skip = skip,
                    n_max = chunk_size)

  } else if (file_format %in% c("Stata")) {

    tbl <- read_dta(file = path_to_table,
                    skip = skip,
                    n_max = chunk_size)
  }

  if (nrow(tbl) != 0) {
    parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_table)))
    parquetizename <- paste0(parquetname,sprintf("%d",skip+1),"-",sprintf("%d",skip+chunk_size),".parquet")

    write_parquet(tbl,
                  sink = file.path(path_to_parquet,
                                   parquetizename),
                  ...
    )
    cli_alert_success("\nThe {file_format} file is available in parquet format under {path_to_parquet}/{parquetizename}")
  }

  completed <- nrow(tbl) < chunk_size
  return(!completed)
}

#' @name get_lines_for_memory
#'
#' @title Utility to guess the number of lines fiting in given memory_size
#'
#' @param path_to_table string that indicates the path to the input file (don't forget the extension).
#' @param memory_size memory (in Mo) to use for one chunk, default to 4000Mb
#' @param sample_lines number of line to read to begin. default is 10000
#'
#' This method read a sample of `sample_lines` to estimate the number lines that
#' fit in argument memory_size.
#'
#' @noRd
#' @importFrom utils object.size
get_lines_for_memory <- function(path_to_table, chunk_memory_size = 4000, sample_lines = 10000) {
  read_method <- get_read_function_for_file(path_to_table)
  data <- read_method(path_to_table, n_max = sample_lines)

  data_memory_size <- object.size(data)
  # cosmetic : remove object.size attribute
  attributes(data_memory_size) <- NULL

  # chunk_memory_size is in Mb and data_memory_size in bytes
  lines <- ceiling(chunk_memory_size * 1024 * 1024 * nrow(data) / data_memory_size)
  lines
}

read_function_by_extension <- list(
  "sas7bdat" = haven::read_sas,
  "sav" = haven::read_sav,
  "dta" = haven::read_dta
)

#' @name get_read_function_for_file
#'
#' @title Utility that returns the haven method to use for given file
#'
#' @param file_name string that indicates the path to the input file
#'
#' @noRd
#' @importFrom tools file_ext
get_read_function_for_file <- function(file_name) {
  ext <- tools::file_ext(file_name)
  if (ext == "") {
    cli_alert_danger("Be careful, unable to find a read method for \"{file_name}\", it has no extension")
    stop("")
  }

  fun <- read_function_by_extension[[ext]]
  if (is.null(fun)) {
    cli_alert_danger("Be careful, no method to read \"{file_name}\" file")
    stop("")
  }

  fun
}

