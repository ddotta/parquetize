################################################################################################%#
#### Code to create the csv/txt file `region_2022.csv` and `region_2022.txt` in `inst/extdata`####
################################################################################################%#

# The file `region_2022.csv` comes from the site insee.fr.
# It can be downloaded at the following URL :
# https://www.insee.fr/fr/information/6051727

library(curl)
library(readr)

zipinseefr <- curl_download("https://www.insee.fr/fr/statistiques/fichier/6051727/cog_ensemble_2022_csv.zip",
                             tempfile())
filesinseefr <- unzip(zipfile=zipinseefr)

region_2022 <- read_delim(filesinseefr[11],
                          show_col_types = FALSE)

write.csv2(
  region_2022,
  file = "inst/extdata/region_2022.csv",
  row.names = FALSE)

write.table(
  region_2022,
  file = "inst/extdata/region_2022.txt",
  row.names = FALSE
)
