#################################################################%#
#### Code to create the rds file `iris.rds sous `inst/extdata`####
###############################################################%#

data(iris)

saveRDS(object = iris,
        file = "inst/extdata/iris.rds")
