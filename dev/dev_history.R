#------------------------------------------------------------------------#
# Exemple sous https://linogaliana.gitlab.io/collaboratif/package.html #

####################  AU QUOTIDIEN  ###############################
# 3.a. Inclure du code, le documenter et le tester
# Pour chaque fonction du package :
usethis::use_r("csv_to_parquet")
usethis::use_test("csv_to_parquet")
# écrire le code de la fonction
# documenter la fonction
# # Pour mettre à jour la documentation et le NAMESPACE
# devtools::document()
roxygen2::roxygenise()
# écrire les tests
# exécuter les tests
devtools::test()

# 3.b. Si besoin, déclarer une dépendance dans DESCRIPTION
usethis::use_package("readr")
# pour utiliser %>% dans un package
# usethis::use_pipe()

# Pour réaliser le contrôle de conformité du package
devtools::check()

# 3.c. Astuce qui peut aider durant le développement
# Charger l'ensemble des fonctions de son package
devtools::load_all()
#------------------------------------------------#

# Ajout de  `dev/dev_history.R` au .Rbuildignore
usethis::use_build_ignore("dev/dev_history.R")

# Ajout d'un fichier NEWS
usethis::use_news_md()

# Creation du squelette du pkgdown
usethis::use_pkgdown()

# Configuration des GHA
usethis::use_github_action()

# Ajout des fichiers dans `data-raw`
usethis::use_data_raw("region-2022")

# Creation des vignettes
usethis::use_vignette("aa-conversions")

# Creation du repertoire testthat
usethis::use_testthat()

################ En fin de developpement ##########

# Construction du site (uniquement sur SSP Cloud)
pkgdown::build_site(override = list(destination = "../website"))

# Construction du fichier .tar.gz
devtools::build()

# Construction du fichier .zip (format binaire)
devtools::build(binary=TRUE)

# Construction du manuel au format pdf
devtools::build_manual(path = "manuel")
