#' Convert a json file to parquet format
#'
#' This function allows to convert a \href{https://www.json.org/json-en.html}{json}
#' or \href{http://ndjson.org/}{ndjson} file to parquet format. \cr
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
#' @param path_to_json string that indicates the path to the csv file
#' @param path_to_parquet string that indicates the path to the directory where the parquet file will be stored
#' @param format string that indicates if the format is "json" (by default) or "ndjson"
#' @param partition string ("yes" or "no" - by default) that indicates whether you want to create a partitioned parquet file.
#' If "yes", `"partitioning"` argument must be filled in. In this case, a folder will be created for each modality of the variable filled in `"partitioning"`.
#' @param progressbar string () ("yes" or "no" - by default) that indicates whether you want a progress bar to display
#' @param ... additional format-specific arguments, see \href{https://arrow.apache.org/docs/r/reference/write_parquet.html}{arrow::write_parquet()}
#'  and \href{https://arrow.apache.org/docs/r/reference/write_dataset.html}{arrow::write_dataset()} for more informations.
#' @return A parquet file, invisibly
#'
#' @importFrom jsonlite read_json
#' @importFrom arrow write_parquet read_json_arrow
#' @export
#'
#' @examples
#'
#' # Conversion from a local json file :
#'
#' json_to_parquet(
#'   path_to_json = system.file("extdata","iris.json",package = "parquetize"),
#'   path_to_parquet = tempdir(),
#'   progressbar = "no"
#' )
#'
#' # Conversion from a local ndjson file :
#'
#' json_to_parquet(
#'   path_to_json = system.file("extdata","iris.ndjson",package = "parquetize"),
#'   path_to_parquet = tempdir(),
#'   format = "ndjson",
#'   progressbar = "no"
#' )

json_to_parquet <- function(
    path_to_json,
    path_to_parquet,
    format = "json",
    partition = "no",
    progressbar = "yes",
    ...
) {


  if (progressbar %in% c("yes")) {
    # Initialize the progress bar
    conversion_progress <- txtProgressBar(style = 3)
  }

  # Check if path_to_json is missing
  if (missing(path_to_json)) {
    stop("Be careful, the argument path_to_json must be filled in")
  }

  # Check if path_to_parquet is missing
  if (missing(path_to_parquet)) {
    stop("Be careful, the argument path_to_parquet must be filled in")
  }

  # Check if path_to_parquet exists
  if (dir.exists(path_to_parquet)==FALSE) {
    dir.create(path_to_parquet, recursive = TRUE)
  }

  # Check if format is equal to "json" or "ndjson"
  if (!(format %in% c("json","ndjson"))) {
    stop("Be careful, the argument format must be equal to 'json' or 'ndjson'")
  }

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 1)


  if (format %in% c("json")) {
    json_output <- jsonlite::read_json(path = path_to_json,
                                       simplifyVector = TRUE)
  } else if (format %in% c("ndjson")) {
    json_output <- read_json_arrow(file = path_to_json,
                                   as_data_frame = TRUE)
  }

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 6)

  parquetname <- paste0(gsub("\\..*","",sub(".*/","", path_to_json)),".parquet")

  if (partition %in% c("no")) {

    parquetfile <- write_parquet(json_output,
                                 sink = file.path(path_to_parquet,
                                                  parquetname))

  } else if (partition %in% c("yes")) {

    parquetfile <- write_dataset(json_output,
                                 path = path_to_parquet,
                                 ...)

  }

  update_progressbar(pbar = progressbar,
                     name_progressbar = conversion_progress,
                     value = 10)

  message(paste0("\nThe ",
                 if (format %in% c("json")) {
                 "json"
                 } else if (format %in% c("ndjson")) {
                 "ndjson"
                 },
                 " file is available in parquet format under ",path_to_parquet))

  return(invisible(parquetfile))

}
