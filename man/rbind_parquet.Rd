% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rbind_parquet.R
\name{rbind_parquet}
\alias{rbind_parquet}
\title{Function to bind multiple parquet files by row}
\usage{
rbind_parquet(
  folder,
  output_name,
  delete_initial_files = TRUE,
  compression = "snappy",
  compression_level = NULL
)
}
\arguments{
\item{folder}{the folder where the initial files are stored}

\item{output_name}{name of the output parquet file}

\item{delete_initial_files}{Boolean. Should the function delete the initial files ? By default TRUE.}

\item{compression}{compression algorithm. Default "snappy".}

\item{compression_level}{compression level. Meaning depends on compression algorithm.}
}
\value{
Parquet files, invisibly
}
\description{
This function read all parquet files in \code{folder} argument that starts with \code{output_name},
combine them using rbind and write the result to a new parquet file. \cr

It can also delete the initial files if \code{delete_initial_files} argument is TRUE. \cr

Be careful, this function will not work if files with different structures
are present in the folder given with the argument \code{folder}.
}
\examples{
\dontrun{
library(arrow)
if (file.exists('output')==FALSE) {
  dir.create("output")
}

file.create(fileext = "output/test_data1-4.parquet")
write_parquet(data.frame(
  x = c("a","b","c"),
  y = c(1L,2L,3L)
),
"output/test_data1-4.parquet")

file.create(fileext = "output/test_data4-6.parquet")
write_parquet(data.frame(
  x = c("d","e","f"),
  y = c(4L,5L,6L)
), "output/test_data4-6.parquet")

test_data <- rbind_parquet(folder = "output",
                           output_name = "test_data",
                           delete_initial_files = FALSE)
}
}
