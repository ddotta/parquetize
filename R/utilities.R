#' Utility function that read and write data by chunk
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
    write_parquet(tbl,
                  sink = file.path(path_to_parquet,
                                   paste0("parquetize",sprintf("%d",skip),".parquet"))
    )
  }

  return(not_completed)
}

# Function to read parquet files in a folder, combine them using rbind,
# write the result to a new parquet file, and delete the initial files
#' Utility function that updates a progress bar
#'
#' This function read parquet files in a folder, combine them using rbind and
#' write the result to a new parquet file. It also delete the initial files.
#'
#' @param folder a folder
#' @param output_name name of the output parquet file
#'
#' @importFrom arrow read_parquet
#'
#' @noRd
bychunk_process <- function(folder,
                            output_name) {
  # Get the list of files in the folder
  files <- list.files(folder, pattern = "^parquetize.*\\.parquet$")

  # Initialize an empty list to store the data frames
  data_frames <- list()

  # Loop through the files
  for (file in files) {
    # Read the parquet file into a data frame
    df <- read_parquet(file.path(folder,file))

    # Add the data frame to the list
    data_frames[[file]] <- df
  }

  # Use rbind to combine the data frames into a single data frame
  combined_df <- do.call(rbind, data_frames)

  # Write the combined data frame to a new parquet file
  write_parquet(combined_df, file.path(folder, output_name))

  # Delete the initial parquet files
  unlink(file.path(folder,files))

  return(invisible(combined_df))
}
