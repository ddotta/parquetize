#' @name rbind_parquet
#'
#' @title Function to bind multiple parquet files by row
#'
#' @description This function read all parquet files in `folder` argument that starts with `output_name`,
#' combine them using rbind and write the result to a new parquet file. \cr
#'
#' It can also delete the initial files if `delete_initial_files` argument is TRUE. \cr
#'
#' Be careful, this function will not work if files with different structures
#' are present in the folder given with the argument `folder`.
#'
#' @param folder the folder where the initial files are stored
#' @param output_name name of the output parquet file
#' @param delete_initial_files Boolean. Should the function delete the initial files ? By default TRUE.
#' @param compression compression algorithm. Default "snappy".
#' @param compression_level compression level. Meaning depends on compression algorithm.
#'
#' @return Parquet files, invisibly
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(arrow)
#' if (file.exists('output')==FALSE) {
#'   dir.create("output")
#' }
#'
#' file.create(fileext = "output/test_data1-4.parquet")
#' write_parquet(data.frame(
#'   x = c("a","b","c"),
#'   y = c(1L,2L,3L)
#' ),
#' "output/test_data1-4.parquet")
#'
#' file.create(fileext = "output/test_data4-6.parquet")
#' write_parquet(data.frame(
#'   x = c("d","e","f"),
#'   y = c(4L,5L,6L)
#' ), "output/test_data4-6.parquet")
#'
#' test_data <- rbind_parquet(folder = "output",
#'                            output_name = "test_data",
#'                            delete_initial_files = FALSE)
#' }

rbind_parquet <- function(folder,
                          output_name,
                          delete_initial_files = TRUE,
                          compression = "snappy",
                          compression_level = NULL) {

  # Get the list of files in the folder
  files <- list.files(folder, pattern = paste0("^",output_name,".*\\.parquet$"))

  # Initialize an empty list to store the data frames
  data_frames <- list()

  # Loop through the files
  for (file in files) {
    # Read the parquet file into a data frame
    df <- arrow::read_parquet(file.path(folder,file))

    # Add the data frame to the list
    data_frames[[file]] <- df
  }

  # Use rbind to combine the data frames into a single data frame
  combined_df <- do.call(rbind, data_frames)

  # Delete the initial parquet files
  if (isTRUE(delete_initial_files)) {
    unlink(file.path(folder,files))
  }

  # Write the combined data frame to a new parquet file
  arrow::write_parquet(combined_df,
                file.path(folder, paste0(output_name,".parquet")),
                compression = compression,
                compression_level = compression_level)

  cli_alert_success("\nThe {output_name} parquet file is available under {folder}")

  return(invisible(combined_df))
}
