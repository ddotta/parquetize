% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_partitions.R
\name{get_partitions}
\alias{get_partitions}
\title{get unique values from table's column}
\usage{
get_partitions(conn, table, column)
}
\arguments{
\item{conn}{A \code{DBIConnection} object, as return by \code{DBI::dbConnect}}

\item{table}{a DB table name}

\item{column}{a column name for the table passed in param}
}
\value{
a vector with unique values for the column of the table
}
\description{
This function allows you to extract unique values from a table's column to use as partitions.\cr

Internally, this function does "SELECT DISTINCT(\code{mycolumn}) FROM \code{mytable};"
}
\examples{
dbi_connection <- DBI::dbConnect(RSQLite::SQLite(),
  system.file("extdata","iris.sqlite",package = "parquetize"))

get_partitions(dbi_connection, "iris", "Species")
}
