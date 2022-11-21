table_to_parquet <- function(
    path_to_table,
    path_to_parquet,
    ...
) {

  # Check if path_to_table is missing
  if (missing(path_to_table)) {
    stop("Be careful, the argument path_to_table must be filled in")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    stop("Be careful, the argument path_to_parquet must be filled in")
  }

  if (missing(path_to_table)==FALSE) {

    extension <- sub(".*/","", path_to_table)

    if (extension %in% c("sas7bdat")) {

      file_format <- "SAS"
      table_output <- read_sas(path_to_table)

    } else if (extension %in% c("sav")) {

      file_format <- "SPSS"
      table_output <- read_sav(path_to_table)

    } else if (extension %in% c("dta")) {

      file_format <- "Stata"
      table_output <- read_dta(path_to_table)

    }

    table_output[] <- lapply(table_output, function(x) {attributes(x) <- NULL; x})

    parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_table)),".parquet")

  }

  parquetfile <- write_parquet(table_output,
                               sink = file.path(path_to_parquet,
                                                parquetname),
                               ...
  )

  message(paste0("The ", file_format," file is available in parquet format under ",path_to_parquet))

  return(invisible(parquetfile))

}

