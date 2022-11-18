#####################################################%#
#### Code to create the csv file `region_2022.csv ####
###################################################%#

# The file `region_2022.csv` comes from the site insee.fr.
# It can be downloaded at the following URL :
# https://www.insee.fr/fr/information/6051727

library(curl)
library(readr)

zipinseefr <- curl_download("https://www.insee.fr/fr/statistiques/fichier/6051727/cog_ensemble_2022_csv.zip",
                             tempfile())
filesinseefr <- unzip(zipfile=zipinseefr)
names(filesinseefr) <- sub('.*/', '', filesinseefr)

region_2022 <- read_delim(filesinseefr[region_2022.csv])

# Anonymisation des SIREN et des raison sociales
SSP_aero_2019 <- SSP_aero_2019 %>%
  slice(1:100) %>%
  mutate(
    siret = paste0("F",as.character(sample(999999:99999999,100))),
    rs = paste0("Etablissement ",row_number()))

# Code pour produire la base exemple au format csv sous
# `inst/extdata`
write.csv2(
  SSP_aero_2019,
  file = "inst/extdata/SSP_aero_2019.csv",
  row.names = FALSE)

# Code pour générer la base exemple au format rda sous `data`
usethis::use_data(SSP_aero_2019, overwrite = TRUE)


usethis::use_data(region-2022, overwrite = TRUE)
