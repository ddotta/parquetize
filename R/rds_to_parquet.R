#' Convert a rds file to parquet format
#'
#' This function allows to convert a rds file to parquet format. \cr
#'
#' Two conversions possibilities are offered :
#'
#'\itemize{
#'
#' \item{Convert to a single parquet file. Argument `path_to_parquet` must then be used;}
#' \item{Convert to a partitioned parquet file. Additionnal arguments `partition` and `partitioning` must then be used;}
#'
#' }
#'
#' @param path_to_rds string that indicates the path to the rds file
#' @param path_to_parquet string that indicates the path to the directory where the parquet file will be stored
#' @param partition string ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' @param progressbar string () ("yes" or "no" - by default) that indicates whether you want a progress bar to display
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @importFrom arrow write_parquet
#' @export
#'
#' @examples
#'
#' # Conversion from a local rds file to a single parquet file ::
#'
#' rds_to_parquet(
#'   path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
#'   path_to_parquet = tempdir(),
#'   progressbar = "no"
#' )
#'
#' # Conversion from a local rds file to a partitioned parquet file  ::
#'
#' rds_to_parquet(
#'   path_to_rds = system.file("extdata","iris.rds",package = "parquetize"),
#'   path_to_parquet = tempdir(),
#'   progressbar = "no",
#'   partition = "yes",
#'   partitioning =  c("Species")
#' )

rds_to_parquet <- function(
    path_to_rds,
    path_to_parquet,
    partition = "no",
    progressbar = "yes",
    ...
) {


  if (progressbar %in% c("yes")) {
    # Initialize the progress bar
    conversion_progress <- txtProgressBar(style = 3)
  }

  # Check if path_to_rds is missing
  if (missing(path_to_rds)) {
    stop("Be careful, the argument path_to_rds must be filled in")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    stop("Be careful, the argument path_to_parquet must be filled in")
  }

  # Check if path_to_parquet exists
  if (dir.exists(path_to_parquet)==FALSE) {
    dir.create(path_to_parquet, recursive = TRUE)
  }

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 1)


  rds_output <- readRDS(file = path_to_rds)

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 6)

  parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_rds)),".parquet")

  if (partition %in% c("no")) {

    parquetfile <- write_parquet(rds_output,
                                 sink = file.path(path_to_parquet,
                                                  parquetname))

  } else if (partition %in% c("yes")) {

    parquetfile <- write_dataset(rds_output,
                                 path = path_to_parquet,
                                 ...)

  }

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 10)

  message(paste0("\nThe rds file is available in parquet format under ",path_to_parquet))

  return(invisible(parquetfile))

}
