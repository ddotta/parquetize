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
