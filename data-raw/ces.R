#####################################################################%#
#### Code to create the csv file `ces.sas7bdat sous `inst/extdata`####
###################################################################%#

# The file `ces.sas7bdat` comes from the site principlesofeconometrics.com.
# It can be downloaded at the following URL :
# http://www.principlesofeconometrics.com/sas.htm

library(curl)
library(readr)

dir.create("Data")

zipeconometrics <- curl_download("http://www.principlesofeconometrics.com/zip_files/sas.zip",
                                 tempfile())
fileseconometrics <- unzip(zipfile=zipeconometrics)

file.copy(from ="ces.sas7bdat",
          to = "inst/extdata",
          overwrite = TRUE)
