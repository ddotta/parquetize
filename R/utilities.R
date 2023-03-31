#' @name get_lines_for_memory
#'
#' @title Utility to guess the number of lines fiting in given memory_size
#'
#' @param data a tibble/dataframe of equivalent with the data sample used to guess memory
#' @param memory_size memory (in Mo) to use for one chunk, default to 4000Mb
#'
#' This method tries to estimate the number lines that fit in argument
#' memory_size
#'
#' @noRd
#' @importFrom utils object.size
get_lines_for_memory <- function(data, chunk_memory_size = 4000) {
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


file_format_list <- list(
  "sas7bdat" = "SAS",
  "sav" = "SPSS",
  "dta" = "Stata"
)

#' @name get_file_format
#'
#' @title Utility that returns the file format for a file
#'
#' @param file_name string that indicates the path to the input file
#'
#' @noRd
#' @importFrom tools file_ext
get_file_format <- function(file_name) {
  extension <- tools::file_ext(file_name)
  file_format_list[[extension]]
}

#' @name get_parquet_file_name
#'
#' @title Utility that build the parquet file name from input file name
#'
#' @param file_name the file name
#' @return the parquet file name
#'
#' @noRd
get_parquet_file_name <- function(file_name) {
  extension <- tools::file_ext(file_name)
  parquetname <- sub(paste0(extension, "$"), "parquet", basename(file_name))
}

#' @name write_data
#'
#' @title Utility that write parquet file or dataset
#'
#' @param data the data to write
#' @param parquetname the file name for the parquet file
#' @inheritParams table_to_parquet
#'
#' @noRd
write_data_in_parquet <- function(data, path_to_parquet, parquetname, partition, ...) {
  if (partition == "no") {
    parquetfile <- write_parquet(data,
                                 sink = file.path(path_to_parquet,
                                                  parquetname),
                                 ...)
  } else if (partition == "yes") {
    parquetfile <- write_dataset(data,
                                 path = path_to_parquet,
                                 ...)
  }
  parquetfile
}

#' @name is_remote
#'
#' @title Utility to check if file is local or remote
#'
#' @param path file's path
#' @return TRUE if remote, FALSE otherwise
#'
#' @noRd

is_remote <- function(path) {
  grepl('(http|ftp)s?://', path)
}

#' @name is_zip
#'
#' @title Utility to check if file is a zip
#'
#' @param path file's path
#' @return TRUE if zip, FALSE otherwise
#'
#' @noRd

is_zip <- function(path) {
  grepl('\\.zip$', path, ignore.case = TRUE)
}

#' @name get_col_types
#'
#' @title Utility to get informations on the columns
#'
#' @param ds
#'
#' @return a tibble with 3 columns :
#'
#'   * the column name (string)
#'   * the arrow type (string)
#'   * if the column is nullable or not (boolean)
#
#' @noRd
get_col_types <- function(ds) {
  fields <- ds$schema$fields

  tibble(
    name = unlist(lapply(fields, function(x) { x$name })),
    type = unlist(lapply(fields, function(x) { x$type$name })),
    nullable = unlist(lapply(fields, function(x) { x$nullable }))
  )
}
