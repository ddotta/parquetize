#################################################################%#
#### Code to create the rds file `iris.fst sous `inst/extdata`####
###############################################################%#

library(fst)

data(iris)

fst::write.fst(x = iris,
               path = "inst/extdata/iris.fst")
