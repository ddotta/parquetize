sas_to_parquet <- function(
    path_to_sas,
    path_to_parquet,
    compression_type = "snappy",
    compression_level = NULL,
    ...
) {

  # Check if path_to_sas is missing
  if (missing(path_to_sas)) {
    stop("Be careful, the argument path_to_sas must be filled in")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    stop("Be careful, the argument path_to_parquet must be filled in")
  }

  if (missing(path_to_sas)==FALSE) {

    sas_output <- read_sas(path_to_sas)

    parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_sas)),".parquet")

  }

  parquetfile <- write_parquet(sas_output,
                               sink = file.path(path_to_parquet,
                                                parquetname),
                               compression = compression_type,
                               ...
  )

  message(paste0("The csv file is available in parquet format under ",path_to_parquet))

  return(invisible(parquetfile))

}

