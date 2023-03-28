# Checks download_extract fails with error if zip has more than one file and no filename_in_zip

    Code
      download_extract(
        "https://www.insee.fr/fr/statistiques/fichier/3568617/equip-tour-transp-infra-2021.zip")
    Message <cliMessage>
      x Be careful, zip files contains more than one file, you must set filename_in_zip argument
    Error <simpleError>
      

