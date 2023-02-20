#########################################################################################%#
#### Code to create the csv file `iris.parquet and partitioned files to `inst/extdata`####
#######################################################################################%#

library(arrow)

data(iris)

# For iris.parquet
arrow::write_parquet(x = iris,
                     sink = "inst/extdata/iris.parquet")

# For partitioned files

arrow::write_dataset(dataset = iris,
                     path = "inst/extdata/",
                     partitioning = c("Species"))
