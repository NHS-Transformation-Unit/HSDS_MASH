
# MASH Definition Analysis ------------------------------------------------
mash_def_packages <- c("tidyverse",
                       "readxl",
                       "here",
                       "odbc",
                       "DBI",
                       "readr")


# MASH Initial Analysis ---------------------------------------------------
mash_def_packages <- c("tidyverse",
                       "readxl",
                       "here",
                       "odbc",
                       "DBI",
                       "readr")

# load_packages function --------------------------------------------------

load_packages <- function(packages){

missing_packages <- setdiff(packages, installed.packages()[,"Package"])

if (length(missing_packages) > 0) {
  install.packages(missing_packages)
}

lapply(packages, function(pkg) {
  library(pkg, character.only = TRUE)
})

}
