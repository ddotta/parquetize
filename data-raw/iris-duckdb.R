####################################################################%#
#### Code to create the rds file `iris.duckdb sous `inst/extdata`####
##################################################################%#

library(DBI)
library(duckdb)
con <- dbConnect(duckdb(),
                 dbdir="inst/extdata/iris.duckdb",
                 read_only=FALSE)
dbWriteTable(con, "iris", iris)
dbDisconnect(con)
