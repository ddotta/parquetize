#' @name bychunk
#'
#' @title Utility function that read and write data by chunk
#'
#' @param path_to_table string that indicates the path to the input file (don't forget the extension).
#' @param path_to_parquet string that indicates the path to the directory where the parquet files will be stored.
#' @param chunk_size Number of lines that defines the size of the chunk.
#' @param skip Number of lines to ignore when converting.
#'
#'
#' @noRd
bychunk <- function(path_to_table, path_to_parquet, chunk_size, skip, ...) {

  read_method <- get_read_function_for_file(path_to_table)
  tbl <- read_method(path_to_table,
                    skip = skip,
                    n_max = chunk_size)

  if (nrow(tbl) != 0) {
    parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_table)))
    parquetizename <- paste0(parquetname,sprintf("%d",skip+1),"-",sprintf("%d",skip+nrow(tbl)),".parquet")

    write_parquet(tbl,
                  sink = file.path(path_to_parquet,
                                   parquetizename),
                  ...
    )
    cli_alert_success("\nThe {get_file_format(path_to_table)} file is available in parquet format under {path_to_parquet}/{parquetizename}")
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
}
