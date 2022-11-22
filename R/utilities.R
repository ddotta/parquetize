#' Utility function that updates a progress bar
#'
#' @param progressbar a progress bar
#' @param value value of progression (in tenths)
#' @noRd
update_progressbar = function(pbar,
                              name_progressbar,
                              value) {
  if (pbar %in% c("yes")) {
    Sys.sleep(0.1)
    setTxtProgressBar(name_progressbar,value/10)
  }
}

#' Utility function that read a file (SAS, SPSS or Stata) by chunk
#'
#' @param format_export string that indicates the format of the exported file (="SAS"/"SPSS"/"Stata")
#' @noRd
read_by_chunk = function(format_export,
                         path,
                         nb_rows,
                         encoding) {

  liste_tables <- vector("list")
  part <- 1
  step <- 0
  continue <- TRUE
  while(continue) {
    if (format_export %in% c("SAS")) {
      liste_tables[[part]] <-
        read_sas(data_file = path,
                 skip = step,
                 n_max = nb_rows,
                 encoding = encoding)
    } else if (format_export %in% c("SPSS")) {
      liste_tables[[part]] <-
        read_sav(file = path,
                 skip = step,
                 n_max = nb_rows,
                 encoding = encoding)
    } else if (format_export %in% c("Stata")) {
      liste_tables[[part]] <-
        read_dta(file = path,
                 skip = step,
                 n_max = nb_rows,
                 encoding = encoding)
    }

    if (nrow(liste_tables[[part]]) > 0) {
      part <- part + 1
      step <- step + nb_rows
      continue <- TRUE
    } else {
      continue <- FALSE
    }

  }

  table_output <- do.call(rbind,liste_tables)

  return(table_output)

}
