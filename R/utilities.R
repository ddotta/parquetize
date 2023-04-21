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
get_lines_for_memory <- function(data, max_memory = 4000) {
  data_memory_size <- object.size(data)
  # cosmetic : remove object.size attribute
  attributes(data_memory_size) <- NULL

  # max_memory is in Mb and data_memory_size in bytes
  lines <- ceiling(max_memory * 1024 * 1024 * nrow(data) / data_memory_size)
  lines
}

haven_read_function_by_extension <- list(
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
get_haven_read_function_for_file <- function(file_name) {
  ext <- tools::file_ext(file_name)
  if (ext == "") {
    cli_abort("Be careful, unable to find a read method for \"{file_name}\", it has no extension",
              class = "parquetize_bad_argument")
  }

  fun <- haven_read_function_by_extension[[ext]]
  if (is.null(fun)) {
    cli_abort("Be careful, no method to read \"{file_name}\" file",
              class = "parquetize_bad_argument")
  }

  fun
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
#' @title Utility to get informations on parquet file's columns
#'
#' @param ds a dataset/parquet file
#'
#' @return a tibble with 3 columns :
#'
#'   * the column name (string)
#'   * the arrow type (string)
#
#' @noRd
get_col_types <- function(ds) {
  fields <- ds$schema$fields

  tibble(
    name = unlist(lapply(fields, function(x) { x$name })),
    type = unlist(lapply(fields, function(x) { x$type$name })),
  )
}
