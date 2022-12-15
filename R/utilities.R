#' @name bychunk
#'
#' @title Utility function that read and write data by chunk
#'
#' @param file_format file format
#' @param path_to_table string that indicates the path to the input file (don't forget the extension).
#' @param path_to_parquet string that indicates the path to the directory where the parquet files will be stored.
#' @param chunk_size Number of lines that defines the size of the chunk.
#' @param skip Number of lines to ignore when converting.
#' @param encoding string that indicates the character encoding for the input file.
#'
#'
#' @noRd
bychunk <- function(file_format, path_to_table, path_to_parquet, chunk_size, skip, encoding = "utf-8") {

  if (file_format %in% c("SAS")) {

    tbl <- read_sas(data_file = path_to_table,
                    skip = skip,
                    n_max = chunk_size,
                    encoding = encoding)
  } else if (file_format %in% c("SPSS")) {

    tbl <- read_sav(file = path_to_table,
                    skip = skip,
                    n_max = chunk_size,
                    encoding = encoding)

  } else if (file_format %in% c("Stata")) {

    tbl <- read_dta(file = path_to_table,
                    skip = skip,
                    n_max = chunk_size,
                    encoding = encoding)
  }

  not_completed <- nrow(tbl) != 0

  if (isTRUE(not_completed)) {

    parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_table)))
    parquetizename <- paste0(parquetname,sprintf("%d",skip+1),"-",sprintf("%d",skip+chunk_size),".parquet")

    write_parquet(tbl,
                  sink = file.path(path_to_parquet,
                                   parquetizename)
    )

    cli_alert_success("\nThe {file_format} file is available in parquet format under {path_to_parquet}/{parquetizename}")
  }

  return(not_completed)
}
