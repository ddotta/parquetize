####################################################################%#
#### Code to create the rds file `iris.sqlite sous `inst/extdata`####
##################################################################%#

library(RSQLite)
library(DBI)
con <- DBI::dbConnect(RSQLite::SQLite(), "inst/extdata/iris.sqlite")
dbWriteTable(con, "iris", iris)
dbDisconnect(con)
